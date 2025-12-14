import Foundation

import IBeam
import Ligature
import Rearrange
import TextFormation
import Textbook

/// A partial IBeam `TextSystemInterface` implementation that can run TextFormation filters per-cursor.
@MainActor
public final class MultiCursorTransformingPartialSystem<
	BaseSystem: TextFormation.TextSystemInterface
> where BaseSystem.TextRange == NSRange {
	public typealias TextRange = BaseSystem.TextRange
	public typealias Position = TextRange.Bound

	public let textView: PlatformTextView

	private let filterPool: CursorFilterRouter<BaseSystem>
	private let tokenizer: UTF16CodePointTextViewTextTokenizer

	public init(
		baseSystem: BaseSystem,
		textView: PlatformTextView,
		filterProvider: @escaping CursorFilterRouter<BaseSystem>.FilterProvider
	) {
		self.textView = textView
		self.tokenizer = UTF16CodePointTextViewTextTokenizer(textView: textView)
		self.filterPool = CursorFilterRouter(
			baseSystem: baseSystem,
			filterProvider: filterProvider
		)
	}

	public var baseSystem: BaseSystem { filterPool.baseSystem }

	public func cursorsUpdated(added: Set<UUID>, deleted: Set<UUID>, changed: Set<UUID>) {
		filterPool.cursorsUpdated(added: added, deleted: deleted, changed: changed)
	}
}

extension MultiCursorTransformingPartialSystem {
	public func boundingRect(for range: BaseSystem.TextRange) -> CGRect? {
		textView.boundingRect(for: range)
	}
	
	public func position(from position: Position, moving direction: IBeam.TextDirection, by granularity: IBeam.TextGranularity) -> Position? {
		let ligGranularity =  granularity.ligatureGranulaity

		switch direction {
		case .forward:
			return tokenizer.position(from: position, toBoundary: ligGranularity, inDirection: .storage(.forward))
		case .backward:
			return tokenizer.position(from: position, toBoundary: ligGranularity, inDirection: .storage(.backward))
		case .left:
			return tokenizer.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.left))
		case .right:
			return tokenizer.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.right))
		case let .down(alignment):
			return tokenizer.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.down), alignment: alignment)
		case let .up(alignment):
			return tokenizer.position(from: position, toBoundary: ligGranularity, inDirection: .layout(.up), alignment: alignment)
		}
	}

	public func applyMutation(_ mutation: IBeam.TextMutation<TextRange>) throws -> IBeam.MutationOutput<TextRange> {
		try filterPool.applyMutation(mutation)
	}
	
	public var endOfDocument: Position {
		baseSystem.endOfDocument
	}
}
