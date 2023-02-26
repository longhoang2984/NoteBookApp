//
//  Note.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import Foundation

public struct Note: Hashable {
    public let id: UUID
    public let name: String
    public let content: String
    public let createdDate: Date
    public let recordURL: URL?
    public let imageURLs: [URL]?
    public let category: Category
    public let location: Location?
    
    public init(id: UUID,
         name: String,
         content: String,
         createdDate: Date,
         recordURL: URL?,
         imageURLs: [URL]?,
         category: Category,
         location: Location?) {
        self.id = id
        self.name = name
        self.content = content
        self.createdDate = createdDate
        self.recordURL = recordURL
        self.imageURLs = imageURLs
        self.category = category
        self.location = location
    }
}
