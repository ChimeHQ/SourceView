import Cocoa

import SourceView

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
	let window: NSWindow

	override init() {
		self.window = NSWindow(contentViewController: ViewController())
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		window.makeKeyAndOrderFront(self)
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}

final class ViewController: NSViewController {
	let sourceView = SourceView()

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		sourceView.wrapsTextToHorizontalBounds = false

		let scrollView = NSScrollView()
		scrollView.hasHorizontalScroller = true
		scrollView.hasVerticalScroller = true

		NSLayoutConstraint.activate([
			scrollView.widthAnchor.constraint(greaterThanOrEqualToConstant: 400.0),
			scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300.0),
		])

		scrollView.documentView = sourceView

		sourceView.string = "abc"

		self.view = scrollView
	}
}

extension ViewController: NSTextViewDelegate {
	
}
