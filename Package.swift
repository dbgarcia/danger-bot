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
        .package(url: "https://github.com/danger/danger-swift.git", from: "0.3.0"),
        .package(url: "https://github.com/ashfurrow/danger-swiftlint.git", from: "0.4.1"),
        // .package(url: "https://github.com/f-meloni/danger-swift-coverage", from: "1.1.0"),
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["Danger", "DangerSwiftLint"]), //dev
        .target(name: "DangerBoot", dependencies: ["Danger"]),
    ]
)
