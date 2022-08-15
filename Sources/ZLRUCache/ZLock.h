//
//  ZLock.h
//  ZFoundation
//
//  Created by v on 2020/8/18.
//  Copyright © 2020 v. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZLocking <NSObject>

@required
- (void)lock;
- (void)unlock;

@optional
- (BOOL)tryLock;

@end

@interface ZLock : NSObject <ZLocking>

- (BOOL)tryLock;

- (void)lock;

- (void)unlock;

@end

@interface ZLock (Extension)

- (void)lockWithBlock:(void (^NS_NOESCAPE)(void))block;

@end

NS_ASSUME_NONNULL_END
