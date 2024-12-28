#if os(macOS)
import AppKit

import IBeam
import KeyCodes
import Textbook

extension KeyModifierFlags {
	var addingCursor: Bool {
		subtracting(.numericPad) == [.control, .shift]
	}
}

open class MultiCursorTextView: BaseTextView {
	public var operationProcessor: (InputOperation) -> Bool = { _ in false }
    public var cursorOperationHandler: (CursorOperation<NSRange>) -> Void = { _ in }
}

extension MultiCursorTextView {
    open override func insertText(_ input: Any, replacementRange: NSRange) {
        // also should handle replacementRange values

        let attrString: AttributedString

        switch input {
		case let string as String:
            let container = AttributeContainer(typingAttributes)

            attrString = AttributedString(string, attributes: container)
        case let string as NSAttributedString:
            attrString = AttributedString(string)
        default:
            fatalError("This API should be called with NSString or NSAttributedString only")
        }

		if operationProcessor(.insertText(attrString)) {
			return
		}

		super.insertText(input, replacementRange: replacementRange)
    }

    open override func doCommand(by selector: Selector) {
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
}
#endif
