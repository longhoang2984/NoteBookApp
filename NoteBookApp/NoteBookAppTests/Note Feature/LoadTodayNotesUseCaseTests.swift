//
//  LoadTodayNotesUseCaseTests.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import XCTest
import NoteBookApp

final class LoadTodayNotesUseCaseTests: XCTestCase {
    
    
    private class NoteStoreSpy: NoteStore {
        func retrieve(date: Date) throws -> [Note]? {
            return [uniqueNote()]
        }
    }

}

func uniqueNote() -> Note {
    return Note(id: UUID(), name: "Note 1",
                content: "Note Content",
                createdDate: .now.startOfDay(),
                recordURL: nil,
                imageURLs: nil,
                category: Category(id: UUID(), name: "Daily Routine"),
                location: nil)
}
