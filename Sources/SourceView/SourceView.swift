#if canImport(AppKit)
import AppKit

import IBeam
import Rearrange

open class SourceView: MultiCursorTextView {
	private lazy var coordinator = TextSystemCursorCoordinator(
		textView: self,
		system: IBeamTextViewSystem(textView: self)
	)
	/// Create a TextKit 2 view with a default text system integration.
	public init() {
		let container = NSTextContainer.defaultTextKit2Container

		super.init(frame: .zero, textContainer: container)

		postInitSetUp()

		// access this to set it up
		_ = coordinator
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func postInitSetUp() {
		configureForHorizontalScrolling()
		isRichText = false
		wrapsTextToHorizontalBounds = true
	}
}
#endif
