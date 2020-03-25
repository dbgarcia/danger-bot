// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DangerBoot",
    products: [
        .library(name: "DangerBoot", targets: ["DangerBoot"]),
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]) // dev
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"), // dev
        .package(url: "https://github.com/f-meloni/Rocket", from: "1.0.0"), // dev
        .package(url: "https://github.com/orta/Komondor", from: "1.0.0"), // dev
        .package(url: "https://github.com/f-meloni/danger-swift-coverage", from: "1.1.0"),
        .package(url: "https://github.com/f-meloni/danger-swift-xcodesummary", from: "1.2.1"),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "7.8.0"))
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["Danger", "DangerSwiftCoverage", "DangerXCodeSummary", "XcodeProj"]), //dev
        .target(name: "DangerBoot", dependencies: ["Danger"]),
    ]
)
