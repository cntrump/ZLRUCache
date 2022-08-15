//
//  Tests.m
//  
//
//  Created by v on 2022/8/15.
//

@import XCTest;
@import ZLRUCache;

@interface ObjCTests : XCTestCase

@end

@implementation ObjCTests

- (void)testMaximumCount {
    ZLRUCache<NSString *, NSNumber *> *cache = [[ZLRUCache alloc] initWithCapacity:3];
    [cache setObject:@1 forKey:@"key_1"];
    [cache setObject:@2 forKey:@"key_2"];
    [cache setObject:@3 forKey:@"key_3"];
    [cache setObject:@4 forKey:@"key_4"];

    XCTAssertEqual([cache objectForKey:@"key_1"], nil);
}

- (void)testPriority {
    ZLRUCache<NSString *, NSNumber *> *cache = [[ZLRUCache alloc] initWithCapacity:3];
    [cache setObject:@1 forKey:@"key_1"];
    [cache setObject:@2 forKey:@"key_2"];
    [cache setObject:@3 forKey:@"key_3"];

    [cache objectForKey:@"key_1"];

    [cache setObject:@4 forKey:@"key_4"];

    XCTAssertEqual([cache objectForKey:@"key_2"], nil);
    XCTAssertEqual([cache objectForKey:@"key_1"], @1);
}

@end
