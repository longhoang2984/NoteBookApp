//
//  PlatformImage.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

#if canImport(AppKit)
import AppKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias PlatformImage = NSImage
#endif

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias PlatformImage = UIImage
#endif
