import AppKit
import OSLog

open class BaseTextView: NSTextView {
	public typealias OnEvent = (_ event: NSEvent, _ action: () -> Void) -> Void

	private let logger = Logger(subsystem: "com.chimehq.SourceView", category: "BaseTextView")
	private var activeScrollValue: (NSRange, CGSize)?
	public var onKeyDown: OnEvent = { $1() }
	public var onFlagsChanged: OnEvent = { $1() }
	public var onMouseDown: OnEvent = { $1() }

	public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
		super.init(frame: frameRect, textContainer: container)

		self.textContainerInset = CGSize(width: 5.0, height: 5.0)
	}

	public convenience init() {
		self.init(frame: .zero, textContainer: nil)
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension BaseTextView {
	override open var textContainerInset: NSSize {
		get { super.textContainerInset }
		set {
			let effectiveInset = NSSize(width: max(newValue.width, 5.0), height: newValue.height)

			if effectiveInset != newValue {
				logger.warning("textContainerInset has been modified to workaround scrolling bug")
			}

			super.textContainerInset = effectiveInset
		}
	}

	override open func scrollRangeToVisible(_ range: NSRange) {
		// this scroll won't actually happen if the desired location is too far to the trailing edge. This is because at this point the view's bounds haven't yet been resized, so the scroll cannot happen. FB13100459

		self.activeScrollValue = (range, bounds.size)

		super.scrollRangeToVisible(range)
	}

	override open func setFrameSize(_ newSize: NSSize) {
		super.setFrameSize(newSize)

		guard
			let (range, size) = self.activeScrollValue,
			newSize != size
		else {
			return
		}

		// this produces scroll/text flicker. But I'm unable to find a better solution.
		self.activeScrollValue = nil

		DispatchQueue.main.async {
			super.scrollRangeToVisible(range)
		}
	}
}

extension BaseTextView {
	open override func paste(_ sender: Any?) {
		let handled = delegate?.textView?(self, doCommandBy: #selector(paste(_:))) ?? false

		if handled == false {
			super.paste(sender)
		}
	}

	open override func pasteAsRichText(_ sender: Any?) {
		let handled = delegate?.textView?(self, doCommandBy: #selector(pasteAsRichText(_:))) ?? false

		if handled == false {
			super.pasteAsRichText(sender)
		}
	}

	open override func pasteAsPlainText(_ sender: Any?) {
		let handled = delegate?.textView?(self, doCommandBy: #selector(pasteAsPlainText(_:))) ?? false

		if handled == false {
			super.pasteAsPlainText(sender)
		}
	}
}

extension BaseTextView {
	open override func keyDown(with event: NSEvent) {
		onKeyDown(event) {
			super.keyDown(with: event)
		}
	}

	open override func flagsChanged(with event: NSEvent) {
		onFlagsChanged(event) {
			super.flagsChanged(with: event)
		}
	}

	open override func mouseDown(with event: NSEvent) {
		onMouseDown(event) {
			super.mouseDown(with: event)
		}
	}
}
