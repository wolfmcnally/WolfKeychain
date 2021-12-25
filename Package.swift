// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "WolfKeychain",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "WolfKeychain",
            targets: ["WolfKeychain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfBase", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "WolfKeychain",
            dependencies: ["WolfBase"]),
        .testTarget(
            name: "WolfKeychainTests",
            dependencies: ["WolfKeychain"]),
    ]
)
