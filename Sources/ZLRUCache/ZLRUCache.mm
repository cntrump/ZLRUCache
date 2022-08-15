
#import "ZLRUCache.h"
#import "ZLock.h"

@interface ZLRUCache () {
  @private
    NSMutableArray<id> *_FIFOQueue;
    NSMutableArray<id> *_LIFOQueue;
    NSMutableDictionary<id<NSCopying>, id> *_table;
    ZLock *_lock;
    NSUInteger _limits;
    id _memoryWarningObserver;
}

@end

@implementation ZLRUCache

+ (instancetype)cache {
    return [[self alloc] initWithCapacity:10000];
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    if (self = [super init]) {
        _lock = [[ZLock alloc] init];
        _limits = numItems;
        _FIFOQueue = NSMutableArray.array;
        _LIFOQueue = NSMutableArray.array;
        _table = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    }

    return self;
}

- (void)setObject:(nullable id)anObject forKey:(id)aKey {
    id key = [aKey copy];
    id object = anObject;

    if (!key) {
        return;
    }

    typeof(self) sself = self;
    [sself->_lock lockWithBlock:^{
        _table[key] = object;

        if (!object) {
            return;
        }

        if (![_FIFOQueue containsObject:object] && ![_LIFOQueue containsObject:object]) {
            [_FIFOQueue addObject:object];

            if (_FIFOQueue.count + _LIFOQueue.count > _limits && _limits > 0) {
                id expiredObject;
                if (_LIFOQueue.count >= _limits) {
                    expiredObject = _LIFOQueue.lastObject;
                    [_LIFOQueue removeObject:expiredObject];
                } else {
                    expiredObject = _FIFOQueue.firstObject;
                    [_FIFOQueue removeObject:expiredObject];
                }

                [self removeExpiredObject:expiredObject];
            }

            return;
        }

        if ([_FIFOQueue containsObject:object]) {
            [_FIFOQueue removeObject:object];
        }

        if ([_LIFOQueue containsObject:object]) {
            [_LIFOQueue removeObject:object];
        }

        [_LIFOQueue insertObject:object atIndex:0];

        if (_LIFOQueue.count > _limits && _limits > 0) {
            id expiredObject = _LIFOQueue.lastObject;
            [_LIFOQueue removeLastObject];
            [self removeExpiredObject:expiredObject];
        }
    }];
}

- (nullable id)objectForKey:(id)aKey {
    id key = [aKey copy];
    if (!key) {
        return nil;
    }

    __block id object = nil;

    typeof(self) sself = self;
    [sself->_lock lockWithBlock:^{
        object = _table[key];
        if (object) {
            if ([_FIFOQueue containsObject:object]) {
                [_FIFOQueue removeObject:object];
            }

            if ([_LIFOQueue containsObject:object]) {
                [_LIFOQueue removeObject:object];
            }

            [_LIFOQueue insertObject:object atIndex:0];
        }
    }];

    return object;
}

- (void)removeExpiredObject:(id)anObject {
    if (!anObject) {
        return;
    }

    NSDictionary *table = [_table copy];

    NSEnumerator *keyEnumerator = [table keyEnumerator];
    id key = [keyEnumerator nextObject];
    for (; key != nil; key = [keyEnumerator nextObject]) {
        if (table[key] == anObject) {
            [_table removeObjectForKey:key];
        }
    }
}

- (void)removeAllObjects {
    typeof(self) sself = self;
    [sself->_lock lockWithBlock:^{
        [_table removeAllObjects];
        [_FIFOQueue removeAllObjects];
        [_LIFOQueue removeAllObjects];
    }];
}

@end

@implementation ZLRUCache (KeyedSubscript)

- (id)objectForKeyedSubscript:(id)key {
    if (!key) {
        return nil;
    }

    return [self objectForKey:key];
}

- (void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return;
    }

    [self setObject:obj forKey:key];
}

@end
