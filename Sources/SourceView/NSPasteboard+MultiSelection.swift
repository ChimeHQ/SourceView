#if canImport(AppKit)
import AppKit

extension NSPasteboard {
	func multipleTextSelectionStrings(with seperator: String = "\n") -> [String]? {
		// this encodes the number of lines per item
		guard
			let lineCounts = propertyList(forType: .multipleTextSelection) as? [Int],
			let string = string(forType: .string)
		else {
			return nil
		}

		// the actual data is, unforutnately, a flat string seperated by newlines
		var lines = string.components(separatedBy: seperator)
		var array: [String] = []

		for count in lineCounts {
			array.append(lines.prefix(count).joined(separator: seperator))
			lines.removeFirst(count)
		}

		return array
	}

	func setMultipleTextSelectionStrings(_ strings: [String], with seperator: String = "\n") {
		let joined = strings.joined(separator: seperator)
		setString(joined, forType: .string)

		let counts = strings.map { string in
			string.components(separatedBy: seperator).count
		}

		guard counts.count > 1 else { return }

		setPropertyList(counts, forType: .multipleTextSelection)
	}
}
#endif
