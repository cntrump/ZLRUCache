//
//  ZLock.m
//  ZFoundation
//
//  Created by v on 2020/8/18.
//  Copyright © 2020 v. All rights reserved.
//

#import "ZLock.h"
#import <os/lock.h>
#import <pthread.h>


@interface ZSelfGuard () {
 @private
    id _self;
}

@end

@implementation ZSelfGuard

+ (instancetype)guardWithObject:(id)object {
    return [[self alloc] initWithObject:object];
}

- (void)dealloc {
    _self = nil;
}

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _self = object;
    }

    return self;
}

@end

@interface ZLockGuard () {
 @private
    id<ZLocking> _lock;
}

@end

@implementation ZLockGuard

+ (instancetype)guardWithLock:(id<ZLocking>)lock {
    return [[self alloc] initWithLock:lock];
}

- (void)dealloc {
    [_lock unlock];
    _lock = nil;
}

- (instancetype)initWithLock:(id<ZLocking>)lock {
    if (self = [super init]) {
        _lock = lock;
        [lock lock];
    }

    return self;
}

@end


@interface ZLock () {
 @private
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    OS_UNFAIR_LOCK_AVAILABILITY os_unfair_lock _unfairLock;
#endif
    pthread_mutex_t _mutexLock;
}

@end

@implementation ZLock

- (void)dealloc {
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {

    } else {
#endif
        pthread_mutex_destroy(&_mutexLock);
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

- (instancetype)init {
    if (self = [super init]) {
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
        if (@available(iOS 10.0, *)) {
            _unfairLock = OS_UNFAIR_LOCK_INIT;
        } else {
#endif
            pthread_mutex_init(&_mutexLock, NULL);
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
        }
#endif
    }

    return self;
}

- (BOOL)tryLock {
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {
        return os_unfair_lock_trylock(&_unfairLock);
    } else {
#endif
        return pthread_mutex_trylock(&_mutexLock) == 0;
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

- (void)lock {
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&_unfairLock);
    } else {
#endif
        pthread_mutex_lock(&_mutexLock);
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

- (void)unlock {
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_unlock(&_unfairLock);
    } else {
#endif
        pthread_mutex_unlock(&_mutexLock);
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

@end
