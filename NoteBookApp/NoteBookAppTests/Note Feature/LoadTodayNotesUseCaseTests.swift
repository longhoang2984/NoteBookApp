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
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            store.completionRetrieval(with: expectedError)
        }

    }
    
    func test_load_deliversNoNoteInDate() {
        let (sut, store) = makeSUT()
        
        let expectedNotes = [Note]()
        expect(sut, toCompleteWith: .success(expectedNotes)) {
            store.completionRetrieval(with: expectedNotes)
        }
    }
    
    func test_load_deliversNotesInDate() {
        let (sut, store) = makeSUT()
        
        let expectedNotes = [uniqueNote()]
        expect(sut, toCompleteWith: .success(expectedNotes)) {
            store.completionRetrieval(with: expectedNotes)
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
    
    private func expect(_ sut: NoteLoader,
                        toCompleteWith expectedResult: Result<[Note], Error>,
                        when action: () -> Void,
                        file: StaticString = #file, line: UInt = #line) {
        action()
        
        let receivedResult = Result { try sut.load() }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedNotes), .success(expectedNotes)):
            XCTAssertEqual(receivedNotes, expectedNotes, file: file, line: line)
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
        }
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
