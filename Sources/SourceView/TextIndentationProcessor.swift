import Foundation

public struct TextIndentationProcessor {
	public init() {
	}

	func handleInsertTab() -> Bool {
		return false
	}

	func handleInsertBacktab() -> Bool {
		return false
	}

	func handleDeleteBackwards() -> Bool {
		return false
	}

	func handlePaste() -> Bool {
		return false
	}
}

#if os(macOS)
import AppKit

extension TextIndentationProcessor {
	@MainActor
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		switch commandSelector {
		case #selector(NSTextView.insertTab(_:)):
			return textView.withUndo {
				handleInsertTab()
			}
		case #selector(NSTextView.insertBacktab(_:)):
			return textView.withUndo {
				handleInsertBacktab()
			}
		case #selector(NSTextView.deleteBackward(_:)):
			return textView.withUndo {
				handleDeleteBackwards()
			}
		case #selector(NSText.paste(_:)), #selector(NSTextView.pasteAsRichText(_:)), #selector(NSTextView.pasteAsPlainText(_:)):
			return textView.withUndo(named: NSLocalizedString("paste", comment: "Paste command")) {
				handlePaste()
			}
		default:
			return true
		}
	}
}
#endif
