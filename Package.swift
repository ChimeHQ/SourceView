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
		.package(url: "https://github.com/ChimeHQ/Glyph", revision: "63cc672cd1bcc408b3a5158816985c82308e5f83"),
		.package(url: "https://github.com/ChimeHQ/IBeam", revision: "53e0ea98ce3fa299ebbd76bd7b17c561908c763c"),
		.package(url: "https://github.com/ChimeHQ/KeyCodes", from: "1.0.3"),
		.package(url: "https://github.com/ChimeHQ/Ligature", revision: "a43d576b2f453f91c8a55f73f4eecd5ec4425ea2"),
		.package(url: "https://github.com/ChimeHQ/Textbook", revision: "a70d9cd0b7da1878e1db448283b431834fd00376"),
	],
	targets: [
		.target(
			name: "SourceView",
			dependencies: [
				"Glyph",
				"IBeam",
				"KeyCodes",
				"Ligature",
				"Textbook",
			]
		),
		.testTarget(name: "SourceViewTests", dependencies: ["SourceView"]),
	]
)
