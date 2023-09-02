import AppKit

public extension NSTextView {
	/// Wraps operations in an undo group that will also restore selection
	func withUndo<T>(named name: String? = nil, _ block: () throws -> T) rethrows -> T {
		let currentSelection = selectedRanges

		undoManager?.beginUndoGrouping()

		if let name = name {
			undoManager?.setActionName(name)
		}

		undoManager?.registerUndo(withTarget: self, handler: { view in
			view.selectedRanges = currentSelection
		})

		let value = try block()

		undoManager?.endUndoGrouping()

		return value
	}
}
