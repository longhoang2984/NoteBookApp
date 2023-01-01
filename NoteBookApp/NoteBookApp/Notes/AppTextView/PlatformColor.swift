//
//  PlatformColor.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

#if os(macOS)
import AppKit

/**
 This typealias bridges platform-specific colors to simplify
 multi-platform support.
 */
public typealias PlatformColor = NSColor
#endif


#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

/**
 This typealias bridges platform-specific colors to simplify
 multi-platform support.
 */
public typealias PlatformColor = UIColor
#endif
