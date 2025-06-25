// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Vehicle",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Vehicle",
            targets: ["Vehicle"]
        ),
    ],
    dependencies: [
        .package(path: "../Utilities/QRCodeScanner"),
        .package(path: "../Utilities/NetworkClient"),
        .package(path: "../Utilities/DesignSystem"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Vehicle",
            dependencies: ["QRCodeScanner", "NetworkClient", "DesignSystem"]
        ),
        .testTarget(
            name: "VehicleTests",
            dependencies: [
                "Vehicle",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)
