import Foundation

import IBeam
import Rearrange
import TextFormation

extension IBeam.MutationOutput {
	init(_ value: TextFormation.MutationOutput<TextRange>) {
		self.init(selection: value.selection, delta: value.delta)
	}
}

public final class CursorFilterRouter<CompletingSystem: TextFormation.TextSystemInterface> {
	public typealias FilterProvider = () -> any Filter<CompletingSystem>
	public typealias TextRange = CompletingSystem.TextRange

	private var cursorFilters: [UUID: any Filter<CompletingSystem>]

	public let filterProvider: FilterProvider
	public let baseSystem: CompletingSystem

	public init(baseSystem: CompletingSystem, filterProvider: @escaping FilterProvider) {
		self.cursorFilters = [:]
		self.filterProvider = filterProvider
		self.baseSystem = baseSystem
	}

	public func cursorsUpdated(added: Set<UUID>, deleted: Set<UUID>, changed: Set<UUID>) {
		for id in deleted {
			cursorFilters[id] = nil
		}
	}

	/// Process an IBeam mutation by running it through a per-cursor filter.
	public func applyMutation(_ ibeamMutation: IBeam.TextMutation<TextRange>) throws -> IBeam.MutationOutput<TextRange> {
		let cursorId = ibeamMutation.cursorId

		var filter = cursorFilters[cursorId, default: filterProvider()]

		let offset = ibeamMutation.offset
		if offset != 0 {
			try filter.processShift(by: offset, interface: baseSystem)
		}

		let attrString = NSAttributedString(ibeamMutation.string)
		let mutation = TextMutation(
			range: ibeamMutation.range,
			interface: baseSystem,
			string: attrString.string
		)

		let filterOutput = try filter.processMutation(mutation)

		cursorFilters[cursorId] = filter

		if let filterOutput {
			return IBeam.MutationOutput(filterOutput)
		}

		let output = try baseSystem.applyMutation(ibeamMutation.range, string: attrString.string)

		return IBeam.MutationOutput(output)
	}
}
