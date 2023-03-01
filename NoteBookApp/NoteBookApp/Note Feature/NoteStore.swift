//
//  NoteStore.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import Foundation

public protocol NoteStore {
    func retrieve(date: Date) throws -> [Note]?
    func insert(_ note: Note) throws
    func update(_ note: Note) throws
}
