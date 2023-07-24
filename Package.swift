// swift-tools-version: 5.5

import PackageDescription

let package = Package(
	name: "SourceView",
	products: [
		.library(name: "SourceView", targets: ["SourceView"]),
	],
	dependencies: [
	]
	targets: [
		.target(name: "SourceView"),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"]),
	]
)
