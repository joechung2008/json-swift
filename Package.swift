// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "json-swift",
  products: [
    .library(
      name: "JsonCore",
      targets: ["JsonCore"]
    ),
    .executable(
      name: "json-swift",
      targets: ["json-swift"]
    ),
  ],
  targets: [
    .target(
      name: "JsonCore"
    ),
    .executableTarget(
      name: "json-swift",
      dependencies: ["JsonCore"],
      path: "Sources/cli"
    ),
    .testTarget(
      name: "JsonCoreTests",
      dependencies: ["JsonCore"],
      path: "Tests/JsonCoreTests"
    ),
  ]
)
