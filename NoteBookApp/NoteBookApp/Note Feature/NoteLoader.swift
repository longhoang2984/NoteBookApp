//
//  NoteLoader.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import Foundation

public final class NoteLoader {
    private let store: NoteStore
    private let date: () -> Date
    
    public init(store: NoteStore, date: @escaping () -> Date) {
        self.store = store
        self.date = date
    }
}

extension NoteLoader {
    public func load() throws -> [Note] {
        if let notes = try store.retrieve(date: date()) {
            return notes
        }
        
        return []
    }
    
    public func save(_ note: Note) throws {
        try store.insert(note)
    }
}
