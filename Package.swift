// swift-tools-version: 5.6

import PackageDescription


let package = Package(
    name: "Swiftmix",
    platforms: [.macOS(.v11)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Swiftmix"
        ),
        .testTarget(
            name: "SwiftmixTests",
            dependencies: ["Swiftmix"],
            exclude: ["Resources"]
        ),
    ]
)
