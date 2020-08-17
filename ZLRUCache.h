//
//  ZLRUCache.h
//  ZFoundation
//
//  Created by v on 2020/8/16.
//  Copyright © 2020 v. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLRUCache<KeyType, ObjectType> : NSObject

@property(nonatomic, readonly) NSInteger capacity;
@property(nonatomic, readonly) NSInteger count;


- (instancetype)initWithCapacity:(NSInteger)capacity NS_DESIGNATED_INITIALIZER;

- (void)setObject:(ObjectType _Nullable)obj forKey:(KeyType _Nonnull)key;

- (ObjectType _Nullable)objectForKey:(KeyType _Nonnull)key;

- (void)setObject:(ObjectType _Nullable)obj forKeyedSubscript:(KeyType _Nonnull)key;

- (ObjectType _Nullable)objectForKeyedSubscript:(KeyType _Nonnull)key;

- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
