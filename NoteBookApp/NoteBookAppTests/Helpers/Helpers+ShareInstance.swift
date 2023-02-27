//
//  Helpers+ShareInstance.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 27/02/2023.
//

import Foundation
import NoteBookApp

func uniqueNote() -> Note {
    return Note(id: UUID(), name: "Note 1",
                content: "Note Content",
                createdDate: .now.startOfDay(),
                recordURL: nil,
                imageURLs: nil,
                category: Category(id: UUID(), name: "Daily Routine"),
                location: nil)
}

func anyError() -> NSError {
    NSError(domain: "error", code: 400)
}
