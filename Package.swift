// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "WODVault",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/BrettRToomey/Jobs.git", .upToNextMajor(from: "1.1.2")),
        .package(url: "https://github.com/nmdias/FeedKit.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/vapor-community/postgresql-driver.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentProvider", "Jobs", "FeedKit", "PostgreSQLDriver"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)
