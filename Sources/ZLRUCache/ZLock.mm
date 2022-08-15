//
//  ZLock.mm
//  ZFoundation
//
//  Created by v on 2020/8/18.
//  Copyright © 2020 v. All rights reserved.
//

#import "ZLock.h"
#import <os/lock.h>
#import <pthread.h>

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
    typeof(self) sself = self;
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {
        return os_unfair_lock_trylock(&sself->_unfairLock);
    } else {
#endif
        return pthread_mutex_trylock(&sself->_mutexLock) == 0;
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

- (void)lock {
    typeof(self) sself = self;
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&sself->_unfairLock);
    } else {
#endif
        pthread_mutex_lock(&sself->_mutexLock);
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

- (void)unlock {
    typeof(self) sself = self;
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_unlock(&sself->_unfairLock);
    } else {
#endif
        pthread_mutex_unlock(&sself->_mutexLock);
#ifdef OS_UNFAIR_LOCK_AVAILABILITY
    }
#endif
}

@end

@implementation ZLock (Extension)

- (void)lockWithBlock:(void (^NS_NOESCAPE)(void))block {
    if (!block) {
        return;
    }
    
    [self lock];
    block();
    [self unlock];
}

@end
