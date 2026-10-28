// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ControlFinanzas",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ControlFinanzas",
            targets: ["ControlFinanzas"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ControlFinanzas",
            dependencies: [],
            path: "Sources/ControlFinanzas"
        ),
        .testTarget(
            name: "ControlFinanzasTests",
            dependencies: ["ControlFinanzas"],
            path: "Tests/ControlFinanzasTests"
        ),
    ]
)
