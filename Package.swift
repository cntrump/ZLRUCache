// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZLRUCache",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "ZLRUCache",
            targets: [ "ZLRUCache" ]
        )
    ],
    targets: [
        .target(
            name: "ZLRUCache",
            publicHeadersPath: "."
        ),
        .testTarget(name: "ObjCTests", dependencies: [ "ZLRUCache" ]),
        .testTarget(name: "SwiftTests", dependencies: [ "ZLRUCache" ])
    ],
    cxxLanguageStandard: .gnucxx14
)
