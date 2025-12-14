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
		
		pasteboard.setString("hello", forType: .string)
		pasteboard.setPropertyList("abc", forType: .multipleTextSelection)
		
		view.paste(self)
		
		switch value {
		default:
			break
		}
    }
}
