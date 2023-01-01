//
//  AppTextContext.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

import SwiftUI

public class AppTextContext: ObservableObject {
    /**
     Create a new rich text context.
     */
    public init() {}


    /**
     The currently selected range, if any.

     Note that this property is currently not @Published, in
     order to avoid redrawing the entire app. We should find
     a way to make it published once more without it causing
     the entire app to redraw every time the cursor is moved.
     Until then, the property has been made read-only, while
     a hopefully temporary `selectedRangeChange` property is
     now used by ``selectRange(_:)``.
     */
    public internal(set) var selectedRange = NSRange()

    /**
     The selected range to change to.
     */
    @Published
    var selectedRangeChange = NSRange()


    /**
     The current background color, if any.
     */
    @Published
    public var backgroundColor: PlatformColor?

    /**
     Whether or not the current rich text can be copied.
     */
    @Published
    public var canCopy = false

    /**
     Whether or not the latest undone change can be redone.
     */
    @Published
    public var canRedoLatestChange = false

    /**
     Whether or not the latest change can be undone.
     */
    @Published
    public var canUndoLatestChange = false

    /**
     The current font name.
     */
    @Published
    public var fontName = ""

    /**
     The current font size.
     */
    @Published
    public var fontSize = CGFloat.standardRichTextFontSize

    /**
     The current foreground color, if any.
     */
    @Published
    public var foregroundColor: PlatformColor?

    /**
     The currently highlighted range, if any.
     */
    @Published
    public var highlightedRange: NSRange?

    /**
     The style to apply when highlighting a range.
     */
    @Published
    public var highlightingStyle = AppTextHighlightingStyle.standard

    /**
     Whether or not the current text is bold.
     */
    @Published
    public var isBold = false

    /**
     Whether or not the rich text is currently being edited.
     */
    @Published
    public var isEditingText = false

    /**
     Whether or not the current text is italic.
     */
    @Published
    public var isItalic = false

    /**
     Whether or not the current text is striked through.
     */
    @Published
    public var isStrikethrough = false

    /**
     Whether or not the current text is underlined.
     */
    @Published
    public var isUnderlined = false

    /**
     Whether or not to copy the current text selection.
     */
    @Published
    public var shouldCopySelection = false

    /**
     Whether or not to redo the latest undone change.
     */
    @Published
    public var shouldRedoLatestChange = false

    /**
     Set this property to trigger an image paste operation.
     */
    @Published
    public var shouldPasteImage: (image: PlatformImage, atIndex: Int, moveCursor: Bool)?

    /**
     Set this property to trigger an image paste operation.
     */
    @Published
    public var shouldPasteImages: (images: [PlatformImage], atIndex: Int, moveCursor: Bool)?

    /**
     Set this property to trigger a text paste operation.
     */
    @Published
    public var shouldPasteText: (text: String, atIndex: Int, moveCursor: Bool)?

    /**
     Whether or not to undo the latest change.
     */
    @Published
    public var shouldUndoLatestChange = false

    /**
     The current text alignment, if any.
     */
    @Published
    public var textAlignment: AppTextAlignment = .left
}

public extension AppTextContext {

    /**
     Whether or not the context has a selected range.
     */
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }
}

public extension AppTextContext {

    /**
     Copy the current selection to the pasteboard.

     This is only usable on platforms that have a pasteboard.
     */
    func copyCurrentSelection() {
        shouldCopySelection = true
    }

    /**
     Decrement the current font size 1 point.
     */
    func decrementFontSize() {
        decrementFontSize(points: 1)
    }

    /**
     Decrement the current font size.

     - Parameters:
       - points: The number of points to decrement the font size.
     */
    func decrementFontSize(points: UInt) {
        stepFontSize(points: -Int(points))
    }

    /**
     Whether or not a certain style is enabled.
     */
    func hasStyle(_ style: AppTextStyle) -> Bool {
        switch style {
        case .bold: return isBold
        case .italic: return isItalic
        case .strikethrough: return isStrikethrough
        case .underlined: return isUnderlined
        }
    }

    /**
     Set ``highlightedRange`` to a new, optional range.
     */
    func highlightRange(_ range: NSRange?) {
        highlightedRange = range
    }

    /**
     Increment the current font size 1 point.
     */
    func incrementFontSize() {
        incrementFontSize(points: 1)
    }

    /**
     Increment the current font size.

     - Parameters:
       - points: The number of points to increment the font size.
     */
    func incrementFontSize(points: UInt) {
        stepFontSize(points: Int(points))
    }

    /**
     Paste an image into the text view, at a certain index.

     - Parameters:
       - image: The image to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImage(
        _ image: PlatformImage,
        at index: Int,
        moveCursorToPastedContent: Bool = false
    ) {
        shouldPasteImage = (image, index, moveCursorToPastedContent)
    }

    /**
     Paste images into the text view, at a certain index.

     - Parameters:
       - images: The images to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImage(
        _ images: [PlatformImage],
        at index: Int,
        moveCursorToPastedContent: Bool = false
    ) {
        shouldPasteImages = (images, index, moveCursorToPastedContent)
    }

    /**
     Paste text into the text view, at a certain index.

     - Parameters:
       - text: The text to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteText(
        _ text: String,
        at index: Int,
        moveCursorToPastedContent: Bool = false
    ) {
        shouldPasteText = (text, index, moveCursorToPastedContent)
    }

    /**
     Redo the latest undone change.
     */
    func redoLatestChange() {
        shouldRedoLatestChange = true
    }

    /**
     Reset the ``highlightedRange``.
     */
    func resetHighlightedRange() {
        highlightedRange = nil
    }

    /**
     Reset the ``selectedRange``.
     */
    func resetSelectedRange() {
        selectedRange = NSRange(location: 0, length: 0)
    }

    /**
     Set ``selectedRange`` to a new range and start editing.

     - Parameters:
       - range: The range to select.
     */
    func selectRange(_ range: NSRange) {
        isEditingText = true
        selectedRangeChange = range
    }

    /**
     Step the current font size a certain number of points.

     - Parameters:
       - points: The number of points to increase or decrease the font size.
     */
    func stepFontSize(points: Int) {
        fontSize += CGFloat(points)
    }

    /**
     Set ``isEditingText`` to `false`.
     */
    func stopEditingText() {
        isEditingText = false
    }

    /**
     Toggle a certain rich text style.
     */
    func toggle(_ style: AppTextStyle) {
        switch style {
        case .bold: isBold.toggle()
        case .italic: isItalic.toggle()
        case .strikethrough: isStrikethrough.toggle()
        case .underlined: isUnderlined.toggle()
        }
    }

    /**
     Toggle whether or not the text is being edited.
     */
    func toggleIsEditing() {
        isEditingText.toggle()
    }

    /**
     Undo the latest change.
     */
    func undoLatestChange() {
        shouldUndoLatestChange = true
    }
}
