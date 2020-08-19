//
//  ZLock.h
//  ZFoundation
//
//  Created by v on 2020/8/18.
//  Copyright © 2020 v. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSelfGuard : NSObject

+ (instancetype)guardWithObject:(id)object;

- (instancetype)init NS_UNAVAILABLE;

@end


@protocol ZLocking <NSObject>

@required
- (void)lock;
- (void)unlock;

@optional
- (BOOL)tryLock;

@end


@interface ZLockGuard : NSObject

+ (instancetype)guardWithLock:(id<ZLocking>)lock;

- (instancetype)init NS_UNAVAILABLE;

@end


@interface ZLock : NSObject <ZLocking>

- (BOOL)tryLock;

- (void)lock;

- (void)unlock;

@end

NS_ASSUME_NONNULL_END
