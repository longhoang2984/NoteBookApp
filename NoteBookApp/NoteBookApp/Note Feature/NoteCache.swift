//
//  NoteCache.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 02/03/2023.
//

import Foundation

public protocol NoteCache {
    func save(_ note: Note) throws
    func update(_ note: Note) throws
}
