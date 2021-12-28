// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIClient",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "APIClient",
            targets: ["APIClient"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0"))
    ],
    targets: [
        .target(
            name: "APIClient",
            dependencies: [ "Alamofire" ])
    ]
)
