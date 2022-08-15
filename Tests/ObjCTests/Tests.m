
@import XCTest;
@import ZLRUCache;

@interface ObjCTests : XCTestCase

@end

@implementation ObjCTests

- (void)testMaximumCount {
    ZLRUCache<NSString *, NSNumber *> *cache = [[ZLRUCache alloc] initWithCapacity:3];
    cache[@"key_1"] = @1;
    cache[@"key_2"] = @2;
    cache[@"key_3"] = @3;
    cache[@"key_4"] = @4;

    XCTAssertEqual(cache[@"key_1"], nil);
}

- (void)testPriority {
    ZLRUCache<NSString *, NSNumber *> *cache = [[ZLRUCache alloc] initWithCapacity:3];
    cache[@"key_1"] = @1;
    cache[@"key_2"] = @2;
    cache[@"key_3"] = @3;

    __unused id _ = cache[@"key_1"];

    cache[@"key_4"] = @4;

    XCTAssertEqual(cache[@"key_2"], nil);
    XCTAssertEqual(cache[@"key_1"], @1);
}

@end
