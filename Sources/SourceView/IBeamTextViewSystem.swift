#if canImport(AppKit)
import AppKit

import IBeam
import Ligature
import Rearrange

extension IBeam.TextGranularity {
	var ligatureGranulaity: Ligature.TextGranularity {
		switch self {
		case .character: .character
		case .word: .word
		case .line: .line
		}
	}
}

@MainActor
public final class IBeamTextViewSystem {
	private weak var textView: NSTextView?
	private var cachedSystem: MutableStringPartialInterface?
	private var cachedId: ObjectIdentifier?

	public init(textView: NSTextView) {
		self.textView = textView
	}

	private var partialSystem: MutableStringPartialInterface {
		let storage = textView?.textStorage ?? NSTextStorage()

		let id = ObjectIdentifier(storage)

		if cachedId == id, let system = cachedSystem {
			return system
		}

		let system = MutableStringPartialInterface(storage)

		self.cachedSystem = system
		self.cachedId = id

		return system
	}

	private var undoManager: UndoManager? {
		textView?.undoManager
	}

	private var tokenizer: UTF16CodePointTextViewTextTokenizer? {
		textView.flatMap { UTF16CodePointTextViewTextTokenizer(textView: $0) }
	}
}

extension IBeamTextViewSystem: @MainActor IBeam.TextSystemInterface {
	public typealias TextRange = NSRange
	public typealias TextPosition = Int

	public func boundingRect(for range: NSRange) -> CGRect? {
		tokenizer?.boundingRect(for: range)
	}

	// movement calculation
	public func position(from position: TextPosition, moving direction: IBeam.TextDirection, by granularity: IBeam.TextGranularity) -> TextPosition? {
		let ligGranularity =  granularity.ligatureGranulaity

		switch direction {
		case .forward:
			return tokenizer?.position(from: position, toBoundary: ligGranularity, inDirection: .storage(.forward))
		case .backward:
			return tokenizer?.position(from: position, toBoundary: ligGranularity, inDirection: .storage(.backward))
		case .left:
			return tokenizer?.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.left))
		case .right:
			return tokenizer?.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.right))
		case let .down(alignment):
			return tokenizer?.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.down), alignment: alignment)
		case let .up(alignment):
			return tokenizer?.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.up), alignment: alignment)
		}
	}

	public func layoutDirection(at position: TextPosition) -> IBeam.TextLayoutDirection? {
		partialSystem.layoutDirection(at: position)
	}

	// range calculation
	public var endOfDocument: TextPosition { partialSystem.endOfDocument }

	// content mutation
	public func beginEditing() { partialSystem.beginEditing() }
	public func endEditing() { partialSystem.endEditing() }

	public func applyMutation(_ mutation: IBeam.TextMutation<NSRange>) throws -> MutationOutput<NSRange> {
		partialSystem.applyMutation(mutation, undoManager: undoManager)
	}

	public func applyMutation(_ range: TextRange, string: String) throws -> MutationOutput<TextRange> {
		partialSystem.applyMutation(range, string: string, undoManager: undoManager)
	}
}
#endif
