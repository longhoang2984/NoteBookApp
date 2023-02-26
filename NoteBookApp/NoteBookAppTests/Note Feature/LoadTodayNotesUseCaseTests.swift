//
//  LoadTodayNotesUseCaseTests.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import XCTest
import NoteBookApp

final class LoadTodayNotesUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receiveMessages, [])
    }
    
    private func makeSUT(date: @escaping () -> Date = Date.init,
                         file: StaticString = #file,
                         line: UInt = #line) -> (sut: NoteLoader, store: NoteStoreSpy) {
        let spy = NoteStoreSpy()
        let loader =  NoteLoader(store: spy, date: date)
        trackForMemoryLeaks(spy)
        trackForMemoryLeaks(loader)
        
        return (loader, spy)
    }
    
    private class NoteStoreSpy: NoteStore {
        
        enum ReceivedMessage: Equatable {
            case retrieve
        }
        
        var receiveMessages: [ReceivedMessage] = []
        
        func retrieve(date: Date) throws -> [Note]? {
            receiveMessages.append(.retrieve)
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
