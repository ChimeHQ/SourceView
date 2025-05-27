#if canImport(AppKit)
import AppKit

import IBeam

open class SourceView: MultiCursorTextView {
	private lazy var coordinator = TextSystemCursorCoordinator(
		textView: self,
		system: IBeamTextViewSystem(textView: self)
	)

	/// Create a TextKit 2 view with a default cursor coordinator.
	public convenience init() {
		let textContainer = NSTextContainer(size: CGSize(width: 1000.0, height: 1.0e7))
		let textContentManager = NSTextContentStorage()
		let textLayoutManager = NSTextLayoutManager()

		textLayoutManager.textContainer = textContainer
		textContentManager.addTextLayoutManager(textLayoutManager)

		self.init(frame: .zero, textContainer: textContainer)

		self.cursorOperationHandler = coordinator.mutateCursors(with:)
		self.operationProcessor = { [coordinator] in
			do {
				try coordinator.processOperation($0)
			} catch {
				print("failed to process input operation \(error)")

				return false
			}

			return true
		}
	}

	/// Create a minimally-configured view.
	public init(frame frameRect: NSRect, textContainer container: NSTextContainer) {
		super.init(frame: frameRect, textContainer: container)

		postInitSetUp()
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func postInitSetUp() {
		// scrolling and resizing
		isVerticallyResizable = true
		isHorizontallyResizable = true
		textContainer?.widthTracksTextView = true
		textContainer?.heightTracksTextView = false
		minSize = NSSize.zero
		maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

		// behaviors
		allowsUndo = true
		isRichText = false
		wrapsTextToHorizontalBounds = true

		if textLayoutManager == nil {
			layoutManager?.allowsNonContiguousLayout = true
		}
	}
}
#endif
