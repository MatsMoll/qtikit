// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QTIKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "QTIKit",
            targets: ["QTIKit"]),
    ],
    dependencies: [
        .package(name: "SwiftSoup", url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "QTIKit",
            dependencies: ["SwiftSoup"]),
        .testTarget(
            name: "QTIKitTests",
            dependencies: ["QTIKit"]),
    ]
)
