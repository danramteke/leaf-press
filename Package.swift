// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "leaf-press",
  platforms: [
    .macOS(.v10_15),
  ],
  products: [
    .executable(name: "leaf-press", targets: ["leaf-press"]),
    .library(name: "LeafPressKit", targets: ["LeafPressKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/iwasrobbed/Down.git", from: "0.9.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git",  from: "0.3.0"),
    .package(url: "https://github.com/vapor/leaf-kit.git", from: "1.0.0"),
  ],
  targets: [      
    .target(name: "leaf-press", 
            dependencies: [
              .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
    .target(name: "LeafPressKit", 
            dependencies: [
              "Down", 
              .product(name: "LeafKit", package: "leaf-kit"),
            ]),
  ])
