//
//  Category.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import Foundation

public struct Category: Hashable {
    public let id: UUID
    public let name: String
    
    public init(id: UUID,
                name: String) {
        self.id = id
        self.name = name
    }
}
