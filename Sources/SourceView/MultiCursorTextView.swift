#if os(macOS)
import AppKit

import IBeam
import KeyCodes
import Textbook
import Rearrange

extension KeyModifierFlags {
	var addingCursor: Bool {
		subtracting(.numericPad) == [.control, .shift]
	}
}

open class MultiCursorTextView: BaseTextView {
	public var operationProcessor: (InputOperation) -> Bool = { _ in false }
	public var cursorOperationHandler: (CursorOperation<NSRange>) -> Void = { _ in }

	private var selectedTextValues: [String] {
		selectedRanges.map { (value: NSValue) -> String in
			let string = textStorage?.string as? NSString

			let substring = string?.substring(with: value.rangeValue) as? String
			return substring ?? ""
		}
	}

	open override func insertText(_ input: Any, replacementRange: NSRange) {
		// also should handle replacementRange values

		let op: InputOperation

		switch input {
		case let string as String:
			op = .insertText(string)
		case let string as NSAttributedString:
			let attrString = AttributedString(string)

			op = .insertAttributedString(attrString)
		default:
			fatalError("This API should be called with NSString or NSAttributedString only")
		}

		if operationProcessor(op) {
			return
		}

		super.insertText(input, replacementRange: replacementRange)
	}

	open override func doCommand(by selector: Selector) {
		// give the delegate a chance
		if delegate?.textView?(self, doCommandBy: selector) == true {
			return
		}

		if let op = InputOperation(selector: selector) {
			if operationProcessor(op) {
				return
			}
		}

		super.doCommand(by: selector)
	}

	// this enable correct routing for the mouse down
	open override func menu(for event: NSEvent) -> NSMenu? {
		if event.keyModifierFlags?.addingCursor == true {
			return nil
		}

		return super.menu(for: event)
	}

	open override func mouseDown(with event: NSEvent) {
		guard event.keyModifierFlags?.addingCursor == true else {
			super.mouseDown(with: event)
			return
		}

		let point = convert(event.locationInWindow, from: nil)
		let index = characterIndexForInsertion(at: point)
		let range = NSRange(index..<index)

		cursorOperationHandler(.add(range))
	}

	open override func keyDown(with event: NSEvent) {
		let flags = event.keyModifierFlags?.subtracting(.numericPad) ?? []
		let key = event.keyboardHIDUsage

		switch (flags, key) {
		case ([.control, .shift], .keyboardUpArrow):
			cursorOperationHandler(.addAbove)
		case ([.control, .shift], .keyboardDownArrow):
			cursorOperationHandler(.addBelow)
		default:
			super.keyDown(with: event)
		}
	}

	open override func copy(_ sender: Any?) {
		let pasteboard = NSPasteboard.general

		pasteboard.clearContents()
		pasteboard.setMultipleTextSelectionStrings(selectedTextValues)
	}

	open override func paste(_ sender: Any?) {
		let pasteboard = NSPasteboard.general

		// this path has no fallback
		if let stringArray = pasteboard.multipleTextSelectionStrings() {
			if operationProcessor(.insertTextArray(stringArray)) == false {
				NSSound.beep()
			}
			
			return
		}

		// a single string paste is different, because it can apply unconditionally to all cursors
		if let string = pasteboard.string(forType: .string) {
			if operationProcessor(.insertText(string)) {
				return
			}
		}

		NSSound.beep()
	}
	
	open override func cut(_ sender: Any?) {
		let pasteboard = NSPasteboard.general

		pasteboard.clearContents()
		pasteboard.setMultipleTextSelectionStrings(selectedTextValues)

		if operationProcessor(.deleteBackwards(.character)) {
			return
		}

		NSSound.beep()
	}

	public override var shouldDrawInsertionPoint: Bool {
		false
	}

	public override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
	}

	public override func updateInsertionPointStateAndRestartTimer(_ restartFlag: Bool) {
		// this needs to be overridden to suppress drawing the insertion point
	}
}
#endif
