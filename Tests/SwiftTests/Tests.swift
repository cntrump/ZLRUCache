//
//  Tests.swift
//  
//
//  Created by v on 2022/8/15.
//

import XCTest
import ZLRUCache

class SwiftTests: XCTestCase {

    func testMaximumCount() {
        let cache = ZLRUCache<NSString, NSNumber>(capacity: 3)
        cache.setObject(1, forKey: "key_1" as NSString)
        cache.setObject(2, forKey: "key_2" as NSString)
        cache.setObject(3, forKey: "key_3" as NSString)
        cache.setObject(4, forKey: "key_4" as NSString)

        XCTAssertEqual(cache.object(forKey: "key_1"), nil)
    }

    func testPriority() {
        let cache = ZLRUCache<NSString, NSNumber>(capacity: 3)
        cache.setObject(1, forKey: "key_1" as NSString)
        cache.setObject(2, forKey: "key_2" as NSString)
        cache.setObject(3, forKey: "key_3" as NSString)

        cache.object(forKey: "key_1")

        cache.setObject(4, forKey: "key_4" as NSString)

        XCTAssertEqual(cache.object(forKey: "key_2"), nil)
        XCTAssertEqual(cache.object(forKey: "key_1"), 1)
    }
}
