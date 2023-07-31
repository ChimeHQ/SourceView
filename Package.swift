// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "SourceView",
	platforms: [.macOS(.v13)],
	products: [
		.library(name: "SourceView", targets: ["SourceView"]),
	],
	dependencies: [
	],
	targets: [
		.target(name: "SourceView"),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"]),
	]
)
