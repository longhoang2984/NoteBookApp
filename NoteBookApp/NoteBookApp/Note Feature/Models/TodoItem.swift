//
//  TodoItem.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import Foundation

public struct TodoItem: Hashable {
    public let id: UUID
    public var name: String
    public var isDone: Bool
    
    public init(id: UUID,
                name: String,
                isDone: Bool) {
        self.id = id
        self.name = name
        self.isDone = isDone
    }
}
