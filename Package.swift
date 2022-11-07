// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MFPSearch",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MFPSearch",
            targets: ["MFPSearch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/FoodLabel", from: "0.0.29"),
        .package(url: "https://github.com/pxlshpr/MFPScraper", from: "0.0.57"),
        .package(url: "https://github.com/pxlshpr/PrepDataTypes", from: "0.0.110"),
        .package(url: "https://github.com/pxlshpr/PrepViews", from: "0.0.21"),
        .package(url: "https://github.com/pxlshpr/SwiftHaptics", from: "0.1.3"),
        .package(url: "https://github.com/pxlshpr/SwiftUISugar", from: "0.0.226"),
        .package(url: "https://github.com/exyte/ActivityIndicatorView", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MFPSearch",
            dependencies: [
                .product(name: "FoodLabel", package: "foodlabel"),
                .product(name: "MFPScraper", package: "mfpscraper"),
                .product(name: "PrepDataTypes", package: "prepdatatypes"),
                .product(name: "PrepViews", package: "prepviews"),
                .product(name: "SwiftHaptics", package: "swifthaptics"),
                .product(name: "SwiftUISugar", package: "swiftuisugar"),
                .product(name: "ActivityIndicatorView", package: "activityindicatorview"),
            ]),
        .testTarget(
            name: "MFPSearchTests",
            dependencies: ["MFPSearch"]),
    ]
)
