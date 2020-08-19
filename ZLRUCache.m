//
//  ZLRUCache.m
//  ZFoundation
//
//  Created by v on 2020/8/16.
//  Copyright © 2020 v. All rights reserved.
//

#import "ZLRUCache.h"
#import <UIKit/UIKit.h>
#import "ZLock.h"


typedef struct ZDualLinkedNode {
    NSObject *key;
    void *data;
    struct ZDualLinkedNode *prev;
    struct ZDualLinkedNode *next;
} ZDualLinkedNode, *ZDualLinkedNodeRef;


@interface ZLRUCache () {
 @private
    ZDualLinkedNodeRef _head;
    ZDualLinkedNodeRef _tail;
    ZLock *_lock;
    NSInteger _capacity;
    NSInteger _count;
    NSMapTable<NSObject *, id> *_hashMap;
}

@end

@implementation ZLRUCache

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIApplicationDidReceiveMemoryWarningNotification
                                                object:nil];
    _lock = nil;
}

- (instancetype)initWithCapacity:(NSInteger)capacity {
    if (self = [super init]) {
        _capacity = capacity;
        _hashMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsOpaqueMemory capacity:capacity];
        _lock = [[ZLock alloc] init];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(receivedMemoryWarningNotification:)
                                                   name:UIApplicationDidReceiveMemoryWarningNotification
                                                 object:nil];
    }

    return self;
}

- (instancetype)init {
    return [self initWithCapacity:0];
}

- (void)addObject:(id)data forKey:(NSObject *)key {
    ZDualLinkedNodeRef node = NULL;

    if (_count < _capacity || _capacity <= 0) {
        _count += 1;
        node = (ZDualLinkedNodeRef)malloc(sizeof(ZDualLinkedNode));
        node->prev = NULL;
        node->next = NULL;
    } else if (_tail) {
        [_hashMap removeObjectForKey:_tail->key];

        node = _tail;
        ZDualLinkedNodeRef prev = _tail->prev;
        if (prev) {
            prev->next = NULL;
        }

        _tail = prev;
        node->prev = NULL;
    }

    node->data = (__bridge_retained void *)data;
    node->key = key.copy;
    node->next = _head;

    if (_head) {
        _head->prev = node;
    }

    _head = node;

    if (!_tail) {
        _tail = node;
    }

    [_hashMap setObject:(__bridge id)node forKey:node->key];
}

- (void)detachNode:(ZDualLinkedNodeRef)node {
    if (!node) {
        return;
    }

    _count -= 1;

    ZDualLinkedNodeRef prev = node->prev;
    ZDualLinkedNodeRef next = node->next;
    if (prev) {
        prev->next = next;
    } else {
        if (next) {
            next->prev = NULL;
        }

        _head = next;
    }

    if (next) {
        next->prev = prev;
    } else {
        if (prev) {
            prev->next = NULL;
        }

        _tail = prev;
    }

    node->prev = NULL;
    node->next = NULL;
}

- (void)removeNode:(ZDualLinkedNodeRef)node {
    if (!node) {
        return;
    }

    [self detachNode:node];

    node->data = NULL;
    node->key = nil;
    free(node);
}

- (ZDualLinkedNodeRef)nodeForKey:(NSObject *)key {
    if (!_head) {
        return NULL;
    }

    for (ZDualLinkedNodeRef p = _head; p != NULL; p = p->next) {
        if ([p->key isEqual:key]) {
            return p;
        }
    }

    return NULL;
}

- (void)insertHead:(ZDualLinkedNodeRef)node {
    [self detachNode:node];

    _count += 1;

    _head->prev = node;
    node->next = _head;
    _head = node;
}

#pragma mark - public methods

- (NSInteger)capacity {
    return _capacity;
}

- (NSInteger)count {
    return _count;
}

- (void)setObject:(id)obj forKey:(NSObject *)key {
    if (!key) {
        return;
    }

    @autoreleasepool {
        __unused ZSelfGuard *selfGuard = [ZSelfGuard guardWithObject:self];
        __unused ZLockGuard *lockGuard = [ZLockGuard guardWithLock:_lock];

        ZDualLinkedNodeRef node = (__bridge ZDualLinkedNodeRef)[_hashMap objectForKey:key];

        if (node) {
            if (obj) {
                node->data = (__bridge_retained void *)obj;
            } else {
                [self removeNode:node];
                [_hashMap removeObjectForKey:key];
            }
        } else {
            [self addObject:obj forKey:key];
        }
    }
}

- (id)objectForKey:(NSObject *)key {
    if (!key) {
        return nil;
    }

    id object = nil;

    @autoreleasepool {
        __unused ZSelfGuard *selfGuard = [ZSelfGuard guardWithObject:self];
        __unused ZLockGuard *lockGuard = [ZLockGuard guardWithLock:_lock];

        ZDualLinkedNodeRef node = (__bridge ZDualLinkedNodeRef)[_hashMap objectForKey:key];
        if (node) {
            object = (__bridge id)node->data;
            [self insertHead:node];
        }
    }

    return object;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSObject *)key {
    [self setObject:obj forKey:key];
}

- (id)objectForKeyedSubscript:(NSObject *)key {
    return [self objectForKey:key];
}

- (void)removeAllObjects {
    @autoreleasepool {
        __unused ZSelfGuard *selfGuard = [ZSelfGuard guardWithObject:self];
        __unused ZLockGuard *lockGuard = [ZLockGuard guardWithLock:_lock];

        for (ZDualLinkedNodeRef p = _tail; p != NULL; p = _tail) {
            [self removeNode:p];
        }

        [_hashMap removeAllObjects];
    }
}

#pragma mark - Notifications

- (void)receivedMemoryWarningNotification:(NSNotification *)notification {
    [self removeAllObjects];
}

@end
