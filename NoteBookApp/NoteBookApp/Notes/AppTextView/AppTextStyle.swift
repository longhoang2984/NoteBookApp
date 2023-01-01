//
//  AppTextStyle.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

import SwiftUI

public enum AppTextStyle: String, CaseIterable, Identifiable {
    case bold
    case italic
    case underlined
    case strikethrough
}

public extension AppTextStyle {
    static var all: [AppTextStyle] { allCases }
}

public extension Collection where Element == AppTextStyle {
    static var all: [AppTextStyle] { AppTextStyle.allCases }
}

public extension AppTextStyle {
    var id: String { rawValue }
}

public extension Collection where Element == AppTextStyle {

    /**
     Whether or not the collection contains a certain style.

     - Parameters:
       - style: The style to look for.
     */
    func hasStyle(_ style: AppTextStyle) -> Bool {
        contains(style)
    }
}

#if canImport(UIKit)
public extension AppTextStyle {

    /**
     The symbolic font traits for the style, if any.
     */
    var symbolicTraits: UIFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: return .traitBold
        case .italic: return .traitItalic
        case .strikethrough: return nil
        case .underlined: return nil
        }
    }
}
#endif

#if os(macOS)
public extension AppTextStyle {

    /**
     The symbolic font traits for the trait, if any.
     */
    var symbolicTraits: NSFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .strikethrough: return nil
        case .underlined: return nil
        }
    }
}
#endif
