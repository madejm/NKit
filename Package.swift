// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "NKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NKit",
            targets: ["NKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NKit",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "NKitTests",
            dependencies: ["NKit"]
        ),
    ]
)
