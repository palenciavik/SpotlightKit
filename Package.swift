// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SpotlightKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SpotlightKit",
            targets: ["SpotlightKit"]
        ),
    ],
    targets: [
        .target(
            name: "SpotlightKit",
            path: "Sources/SpotlightKit"
        ),
        .testTarget(
            name: "SpotlightKitTests",
            dependencies: ["SpotlightKit"],
            path: "Tests/SpotlightKitTests"
        ),
    ]
)

