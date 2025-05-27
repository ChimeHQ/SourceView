#if canImport(AppKit)
import AppKit

extension NSTextView {
	/// Wraps operations in an undo group that will also restore selection
	public func withUndo<T>(named name: String? = nil, _ block: () throws -> T) rethrows -> T {
		let currentSelection = selectedRanges.map({ $0.rangeValue })

		undoManager?.beginUndoGrouping()

		if let name = name {
			undoManager?.setActionName(name)
		}


		undoManager?.registerMainActorUndo(withTarget: self, handler: { view in
			view.selectedRanges = currentSelection.map { NSValue(range: $0) }
		})

		let value = try block()

		undoManager?.endUndoGrouping()

		return value
	}
}
#endif
