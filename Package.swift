// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NickName",
    platforms: [
        .iOS("26.0"),
        .macOS(.v15),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
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
