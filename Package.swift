// swift-tools-version: 5.8

import PackageDescription

let settings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
	name: "SourceView",
	platforms: [.macOS(.v13)],
	products: [
		.library(name: "SourceView", targets: ["SourceView"]),
	],
	dependencies: [
	],
	targets: [
		.target(name: "SourceView", swiftSettings: settings),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"], swiftSettings: settings),
	]
)
