# SourceView
A TextKit 2-enabled `NSTextView` subclasses and handling built specifically to work with source code

This project started as an experiment to see if it is actually even possible to use `NSTextView` + TextKit 2. Prior to macOS 13, the combination had major usability issues. However, as of macOS 14, it is starting to see like it may be ok.

The whole idea here is flexibility. The components in this library are built to be assembled together as part of the text system you need. You can pick and choose, including omitting or overriding as required. Even `BaseTextView` is optional, but it is recommended as it fixes a number of bugs and limitations with stock `NSTextView`.

Features:

- `BaseTextView`: a minimal `NSTextView` subclass to support correct functionality
- `TextMovementProcessor`: uses the `doCommandBy` delegate callback to improve source navigation and selection

## BaseTextView

This is an `NSTextView` subclass that aims for an absolute minimal amount of changes. Things are allowed only if they are required for correct functionality. Behaviors are appropriate for all types of text.

- Workaround for `scrollRangeToVisible` bug (FB13100459)
- Additional routing to `NSTextViewDelegate.textView(_:, doCommandBy:) -> Bool`:  `paste`, `pasteAsRichText`, `pasteAsPlainText`
- Hooks for `onKeyDown`, `onFlagsChanged`, `onMouseDown`

## Event Handling

`NSTextView` has a complex event handling system, especially for key downs. `BaseTextView` provides a number of hooks for observing and controlling that behavior.

```swift
textView.onKeyDown = { event, action in
    // run code before the default action

    // optionally invoke built-in behavior
    action()

    // and run code after that has taken place
}

textView.onFlagsChanged = { event, action in ... }
textView.onMouseDown = { event, action in ... }
```

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

Indentation turns out to be both very complex and potentially expensive. SourceView can be integrated with an indenation calculation system to provide automatic whitespace control for certain operations.

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

## Suggestions and Feedback

I'd love to hear from you! Get in touch via an issue or pull request.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
