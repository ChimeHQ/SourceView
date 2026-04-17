import AppKit
import Testing

import IBeam
import SourceView

@MainActor
struct MultiCursorTextViewTests {
    @Test func paste() async throws {
		let view = MultiCursorTextView(frame: .zero)
		
		var value: InputOperation? = nil
		
		view.operationProcessor = {
			value = $0

			return true
		}
			
		let pasteboard = NSPasteboard.general

		pasteboard.clearContents()
		pasteboard.setString("hello", forType: .string)
		
		view.paste(self)

		guard case .insertText(let string) = value else { Issue.record("invalid operation"); return }

		#expect(string == "hello")
    }
}
