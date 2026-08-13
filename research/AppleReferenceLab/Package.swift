// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "AppleReferenceLab",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "AppleReferenceLab", targets: ["AppleReferenceLab"])
    ],
    targets: [
        .target(name: "ReferenceLabCore"),
        .executableTarget(
            name: "AppleReferenceLab",
            dependencies: ["ReferenceLabCore"]
        ),
        .testTarget(
            name: "ReferenceLabCoreTests",
            dependencies: ["ReferenceLabCore"]
        )
    ]
)
