// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "NickName",
    platforms: [
        .iOS("26.0"),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "NickName",
            targets: ["NickName"]
        ),
    ],
    targets: [
        .target(
            name: "NickName"
        ),
    ]
)
