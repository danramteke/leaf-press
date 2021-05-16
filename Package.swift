// swift-tools-version:5.4

import PackageDescription
import Foundation

let package = Package(
  name: "leaf-press",
  platforms: [
    .macOS("11.0"),
  ],
  products: [
    .executable(name: "leaf-press", targets: ["leaf-press"]),
    .library(name: "LeafPressKit", targets: ["LeafPressKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/iwasrobbed/Down.git", from: "0.9.0"),
    .package(url: "https://github.com/vapor/leaf-kit.git", from: "1.0.0"),
    .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.4"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
    .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
  ],
  targets: [      
    .executableTarget(name: "leaf-press", 
            dependencies: [
              "PathKit",
              "Yams",
              .target(name: "LeafPressKit"),
              .product(name: "ConsoleKit", package: "console-kit"),
            ]),
    .target(name: "LeafPressKit", 
            dependencies: [
              "Down",
              "PathKit",
              "Yams",
              .product(name: "LeafKit", package: "leaf-kit"),
            ],
            resources: [
              .copy("actions/InitAction/scaffold")
            ]
    ),
    .testTarget(name: "LeafPressKitUnitTests",
                dependencies: [
                  "LeafPressKit",
                  "PathKit"
                ]
    ),
    .testTarget(name: "LeafPressKitIntegrationTests",
                dependencies: [
                  "LeafPressKit",
                  "PathKit"
                ],
                resources: [
                  .copy("Fixtures")
                ]
    )
  ])
