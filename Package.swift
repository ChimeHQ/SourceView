// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "SourceView",
	platforms: [
		.macOS(.v14),
		.macCatalyst(.v17),
		.iOS(.v17),
		.visionOS(.v1),
	],
	products: [
		.library(name: "SourceView", targets: ["SourceView"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/IBeam", branch: "main"),
		.package(url: "https://github.com/ChimeHQ/KeyCodes", from: "1.0.3"),
		.package(url: "https://github.com/ChimeHQ/Ligature", branch: "main"),
		.package(url: "https://github.com/ChimeHQ/Rearrange", branch: "main"),
		.package(url: "https://github.com/ChimeHQ/Textbook", revision: "a70d9cd0b7da1878e1db448283b431834fd00376"),
	],
	targets: [
		.target(
			name: "SourceView",
			dependencies: [
				"IBeam",
				"KeyCodes",
				"Ligature",
				"Rearrange",
				"Textbook",
			]
		),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"]),
	]
)
