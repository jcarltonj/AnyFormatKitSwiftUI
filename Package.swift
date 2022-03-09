// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnyFormatKitSwiftUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AnyFormatKitSwiftUI",
            targets: ["AnyFormatKitSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/luximetr/AnyFormatKit", .upToNextMajor(from: "2.5.0"))
    ],
    targets: [
        .target(
            name: "AnyFormatKitSwiftUI",
            dependencies: ["AnyFormatKit"],
            path: "Sources"),
        .testTarget(
            name: "AnyFormatKitSwiftUITests",
            dependencies: ["AnyFormatKitSwiftUI"]),
    ]
)
