// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SpotlightKit",
    platforms: [
        .iOS(.v15)
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
        )
    ]
)

