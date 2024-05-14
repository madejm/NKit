// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "NKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14)
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
