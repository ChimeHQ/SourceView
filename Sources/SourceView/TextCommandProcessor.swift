import Foundation

public struct TextCommandProcessor {
	let movementProcessor = TextMovementProcessor()
	let indentationProcessor = TextIndentationProcessor()

	public init() {
	}
}

#if os(macOS)
import AppKit

extension TextCommandProcessor {
	@MainActor
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if movementProcessor.textView(textView, doCommandBy: commandSelector) == false {
			return false
		}

		if indentationProcessor.textView(textView, doCommandBy: commandSelector) == false {
			return false
		}

		return true
	}
}

#endif
