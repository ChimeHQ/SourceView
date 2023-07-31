// The Swift Programming Language
// https://docs.swift.org/swift-book

#if os(macOS)
import AppKit

open class SourceView: NSTextView {
	public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
		precondition(container?.textLayoutManager != nil)

		super.init(frame: frameRect, textContainer: container)
	}

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
	}
}

extension NSTextView {

}

extension SourceView {
	public override func moveToBeginningOfLine(_ sender: Any?) {
		super.moveToBeginningOfLine(sender)

		scrollRangeToVisible(NSRange(location: insertionLocation!, length: 0))
	}

	public override func moveToLeftEndOfLine(_ sender: Any?) {
		super.moveToLeftEndOfLine(sender)

		let location = textContentStorage?.documentRange.location

		let fragment = textLayoutManager?.textLayoutFragment(for: location!)
		let frame = fragment?.layoutFragmentFrame

		scroll(NSPoint(x: 0.0, y: 0.0))
	}

	public override func invalidateTextContainerOrigin() {
		super.invalidateTextContainerOrigin()
		print(textContainerOrigin)
	}

	public override func moveToRightEndOfLine(_ sender: Any?) {
		super.moveToRightEndOfLine(sender)
	}

	public override func moveToRightEndOfLineAndModifySelection(_ sender: Any?) {
		// interestingly, it seems this isn't the default behavior
		super.moveToRightEndOfLineAndModifySelection(sender)

		guard let range = selectedTextRanges.last else {
			return
		}

		scrollRangeToVisible(NSRange(location: NSMaxRange(range), length: 0))
	}
}

#endif
