import AppKit
import OSLog

open class SourceView: BaseTextView {
	public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
		precondition(container?.textLayoutManager != nil)

		super.init(frame: frameRect, textContainer: container)
	}

	private let logger = Logger(subsystem: "com.chimehq.SourceView", category: "SourceView")

	public init() {
		let textContainer = NSTextContainer(size: CGSize(width: 0.0, height: 1.0e7))
		textContainer.widthTracksTextView = true
		textContainer.heightTracksTextView = false
		let textContentManager = NSTextContentStorage()
		let textLayoutManager = NSTextLayoutManager()
		textLayoutManager.textContainer = textContainer
		textContentManager.addTextLayoutManager(textLayoutManager)

		super.init(frame: .zero, textContainer: textContainer)

		postInitSetUp()
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func postInitSetUp() {
		// scrolling and resizing
		let max = CGFloat.greatestFiniteMagnitude

		minSize = NSSize.zero
		maxSize = NSSize(width: max, height: max)
		isVerticallyResizable = true
		isHorizontallyResizable = true
		autoresizingMask = [.width, .height]

		// behaviors
		allowsUndo = true
//		isRichText = false
	}
}
