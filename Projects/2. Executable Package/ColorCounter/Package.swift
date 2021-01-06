// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorCounter",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(
            name: "ColorCounter",
            targets: ["ColorCounter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", .upToNextMajor(from: "1.5.0")),
        .package(name: "CoolExtensionsLib", url: "https://github.com/ReQEnoxus/SwiftPM-CustomLibrary.git", .upToNextMajor(from:"1.0.0")),
    ],
    targets: [
        .target(
            name: "ColorCounter",
            dependencies: ["ColorizeSwift", "CoolExtensionsLib"]),
        .testTarget(
            name: "ColorCounterTests",
            dependencies: ["ColorCounter"]),
    ]
)
