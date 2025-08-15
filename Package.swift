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
        .library(
            name: "FixedArray",
            targets: ["FixedArray"]
        )
    ],
    targets: [
        .target(
            name: "NKit",
            dependencies: [
                "FixedArray"
            ]
        ),
        .testTarget(
            name: "NKitTests",
            dependencies: [
                "NKit"
            ]
        ),
        .target(
            name: "FixedArray",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "FixedArrayTests",
            dependencies: [
                "FixedArray",
                "NKit"
            ]
        )
    ]
)
