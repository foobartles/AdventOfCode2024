// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2024",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "day01", targets: ["Day01"]),
        .executable(name: "day02", targets: ["Day02"]),
        .executable(name: "day03", targets: ["Day03"]),
        .executable(name: "day04", targets: ["Day04"]),
    ],
    dependencies: [
//        .package(
//          url: "https://github.com/apple/swift-collections.git",
//          .upToNextMinor(from: "1.1.0")
//        )
    ],
    targets: [
        .executableTarget(name: "Day01", dependencies: ["Shared"]),
        .executableTarget(name: "Day02", dependencies: ["Shared"]),
        .executableTarget(name: "Day03", dependencies: ["Shared"]),
        .executableTarget(name: "Day04", dependencies: ["Shared"]),
        .target(name: "Shared", resources: [.process("Inputs")])
    ]
)
