// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACRemoteConfig",
    defaultLocalization: "ru",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "ACRemoteConfig",
            targets: ["ACRemoteConfig"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ACRemoteConfig",
            dependencies: [],
            path: "Sources",
            resources: [.process("Localization")]
        )
    ]
)
