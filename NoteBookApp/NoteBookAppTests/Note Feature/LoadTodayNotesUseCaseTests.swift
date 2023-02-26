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
    
    func test_load_requestsNoteRetrieval() {
        let (sut, store) = makeSUT()
        
        _ = try? sut.load()
        
        XCTAssertEqual(store.receiveMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        let expectedError = anyError()
        store.completionRetrieval(with: expectedError)
        let receivedResult = Result { try sut.load() }
        
        switch receivedResult {
        case let .failure(error):
            XCTAssertEqual(error as NSError, expectedError)
        case .success:
            XCTFail("Expected \(expectedError), got \(receivedResult) instead")
        }
    }
    
    func test_load_deliversNoNoteInDate() {
        let (sut, store) = makeSUT()
        
        let expectedNotes = [Note]()
        store.completionRetrieval(with: expectedNotes)
        let receivedResult = Result { try sut.load() }
        
        switch receivedResult {
        case let .success(receivedNotes):
            XCTAssertEqual(receivedNotes, expectedNotes)
        case .failure:
            XCTFail("Expected \(expectedNotes), got \(receivedResult) instead")
        }
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
        
        private var retrivalResult: Result<[Note], Error>?
        
        func retrieve(date: Date) throws -> [Note]? {
            receiveMessages.append(.retrieve)
            return try retrivalResult?.get()
        }
        
        func completionRetrieval(with error: Error) {
            retrivalResult = .failure(error)
        }
        
        func completionRetrieval(with notes: [Note]) {
            retrivalResult = .success(notes)
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

func anyError() -> NSError {
    NSError(domain: "error", code: 400)
}
