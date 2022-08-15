
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLRUCache<__covariant KeyType, __covariant ObjectType> : NSObject

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;

- (void)setObject:(ObjectType)anObject forKey:(KeyType<NSCopying>)aKey;

- (nullable ObjectType)objectForKey:(KeyType)aKey;

@end

NS_ASSUME_NONNULL_END
