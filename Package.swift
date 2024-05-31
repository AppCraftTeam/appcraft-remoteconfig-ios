// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACRemoteConfig",
    defaultLocalization: "ru",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "ACRemoteConfig",
            targets: ["ACRemoteConfig"]
        ),
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "8.0.0"
        )
    ],
    targets: [
        .target(
            name: "ACRemoteConfig",
            dependencies: [
                .product(
                    name: "FirebaseRemoteConfig",
                    package: "Firebase"
                )
            ],
            path: "Sources",
            resources: [.process("Localization")]
        )
    ]
)
