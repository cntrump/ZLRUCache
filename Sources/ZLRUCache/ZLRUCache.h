
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLRUCache<__covariant KeyType, __covariant ObjectType> : NSObject

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)cache;

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;

- (void)setObject:(nullable ObjectType)anObject forKey:(KeyType<NSCopying>)aKey;

- (nullable ObjectType)objectForKey:(KeyType)aKey;

- (void)removeAllObjects;

@end

@interface ZLRUCache<__covariant KeyType, __covariant ObjectType> (KeyedSubscript)

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;

- (void)setObject:(nullable ObjectType)obj forKeyedSubscript:(KeyType<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
