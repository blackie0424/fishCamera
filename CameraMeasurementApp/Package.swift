// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CameraMeasurementApp",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .executable(name: "CameraMeasurementApp", targets: ["CameraMeasurementApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CameraMeasurementApp",
            dependencies: []
        )
    ]
)