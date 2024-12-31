// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "SourceView",
	platforms: [
		.macOS(.v14),
	],
	products: [
		.library(name: "SourceView", targets: ["SourceView"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/IBeam", revision: "53e0ea98ce3fa299ebbd76bd7b17c561908c763c"),
		.package(url: "https://github.com/ChimeHQ/KeyCodes", from: "1.0.3"),
		.package(url: "https://github.com/ChimeHQ/Ligature", branch: "main"),
		.package(url: "https://github.com/ChimeHQ/Textbook", revision: "a70d9cd0b7da1878e1db448283b431834fd00376"),
	],
	targets: [
		.target(
			name: "SourceView",
			dependencies: [
				"IBeam",
				"KeyCodes",
				"Ligature",
				"Textbook",
			]
		),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"]),
	]
)
