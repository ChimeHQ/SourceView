# SourceView
This project started as an experiment to see if it was actually even possible to use `NSTextView` + TextKit 2. Prior to macOS 13, the combination had major usability issues. As of macOS 14, it is starting to seem like it may work well.

The whole idea here is flexibility. The components in this library are built to be assembled together as part of the text system you need. You can pick and choose, including omitting or overriding as required. `SourceView` is intended to be as subclass-able as `NSTextView`.

Features:

- `BaseTextView`: a minimal `NSTextView` subclass to support correct functionality
- `TextMovementProcessor`: uses the `doCommandBy` delegate callback to improve source navigation and selection

## Integration

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/SourceView")
]
```

## BaseTextView

`SourceView` is a sublcass of `BaseTextView` from [TextViewPlus](https://github.com/chimeHQ/TextViewPlus). That class includes many customization options that can be useful for building a source editor.

## Behaviors

A number of functions have been customized to provide better behavior for code. However, these call all still be further controlled with `NSTextViewDelegate.textView(_:, doCommandBy:) -> Bool`

`moveWordLeft`
`moveWordLeftAndModifySelection`
`moveWordRight`
`moveWordRightAndModifySelection`
`moveToLeftEndOfLine`
`moveToLeftEndOfLineAndModifySelection`

These functions all consider leading/trailing whitespace. And, offer customizable intra-word boundaries for navigation.

## Indentation

Indentation turns out to be both very complex and potentially expensive. SourceView can be integrated with an indentation calculation system to provide automatic whitespace control for certain operations.

`insertTab`: indentation
`insertBacktab`: indentation
`deleteBackward`: indentation
`paste`: indentation
`pasteAsRichText`: converts to plain text
`pasteAsPlainText`: aliased to `paste`

## NSTextView Extensions

```swift
// Restores text selection on undo
func withUndo(named name: String? = nil, _ block: () throws -> Void) rethrows {
```

## Contributing and Collaboration

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

## Contributing and Collaboration

I'd love to hear from you! Get in touch via an issue or pull request.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/SourceView/actions
[build status badge]: https://github.com/ChimeHQ/SourceView/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/SourceView
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FSourceView%2Fbadge%3Ftype%3Dplatforms
