// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2024",
    products: [
        .executable(name: "day01", targets: ["Day01"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/getGuaka/Regex.git", branch: "master"),
//        .package(
//          url: "https://github.com/apple/swift-collections.git",
//          .upToNextMinor(from: "1.1.0")
//        )
    ],
    targets: [
        .target(name: "Day01", dependencies: ["Shared"]),
        .target(name: "Day02", dependencies: ["Shared"]),
        .target(name: "Shared", resources: [.process("Inputs")])
    ]
)
