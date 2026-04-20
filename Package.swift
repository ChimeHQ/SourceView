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
		.package(url: "https://github.com/ChimeHQ/IBeam", revision: "8b13d99609296b3cea828f1fef13269af4a4e7e0"),
		.package(url: "https://github.com/ChimeHQ/KeyCodes", from: "1.0.3"),
		.package(url: "https://github.com/ChimeHQ/Ligature", from: "0.1.0"),
		.package(url: "https://github.com/ChimeHQ/Rearrange", from: "2.1.0"),
		.package(url: "https://github.com/ChimeHQ/TextFormation", branch: "main"),
		.package(url: "https://github.com/ChimeHQ/Textbook", branch: "main"),
	],
	targets: [
		.target(
			name: "SourceView",
			dependencies: [
				"IBeam",
				"KeyCodes",
				"Ligature",
				"Rearrange",
				"TextFormation",
				"Textbook",
			]
		),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"]),
	]
)
