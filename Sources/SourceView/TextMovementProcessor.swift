import Foundation

struct TextMovementProcessor {
	func moveToBeginningOfLine() -> Bool {
		return false
	}

	func handleMoveWordLeft(modifiyingSelection: Bool) -> Bool {
		return false
	}

	func handleMoveWordRight(modifiyingSelection: Bool) -> Bool {
		return false
	}

	func handleMoveToLeftEndOfLine(modifyingSelection: Bool) -> Bool {
		return false
	}
}

#if os(macOS)
import AppKit

extension TextMovementProcessor {
	@MainActor
	func textView(_ aTextView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		switch commandSelector {
		case #selector(NSTextView.moveWordLeft(_:)):
			return handleMoveWordLeft(modifiyingSelection: false)
		case #selector(NSTextView.moveWordLeftAndModifySelection(_:)):
			return handleMoveWordLeft(modifiyingSelection: true)
		case #selector(NSTextView.moveWordRight(_:)):
			return handleMoveWordRight(modifiyingSelection: false)
		case #selector(NSTextView.moveWordRightAndModifySelection(_:)):
			return handleMoveWordRight(modifiyingSelection: true)
		case #selector(NSTextView.moveToLeftEndOfLine(_:)):
			return handleMoveToLeftEndOfLine(modifyingSelection: true)
		case #selector(NSTextView.moveToLeftEndOfLineAndModifySelection(_:)):
			return handleMoveToLeftEndOfLine(modifyingSelection: true)
		default:
			return false
		}
	}
}
#endif
