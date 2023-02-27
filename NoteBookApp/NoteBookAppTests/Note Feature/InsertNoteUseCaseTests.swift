//
//  InsertNoteUseCaseTests.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 27/02/2023.
//

import XCTest
import NoteBookApp

final class InsertNoteUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receiveMessages, [])
    }
    
    func test_save_hasNoSideEffectOnInsertionNote() {
        let (sut, store) = makeSUT()
        
        let note = uniqueNote()
        try? sut.save(note)
        
        XCTAssertEqual(store.receiveMessages, [.insert(note)])
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        
        let expectedError = anyError()
        let note = uniqueNote()
        
        store.completionInsertion(with: expectedError)
        do {
            try sut.save(note)
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_save_successOnInsertionNote() {
        let (sut, store) = makeSUT()
        
        let note = uniqueNote()
        
        store.completionInsertionSuccessfully()
        do {
            try sut.save(note)
        } catch {
            XCTFail("Expected successfully insert note, got \(error) instead")
        }
    }
    
    private func makeSUT(date: @escaping () -> Date = Date.init,file: StaticString = #file, line: UInt = #line) -> (sut: NoteLoader, store: NoteStoreSpy) {
        let store = NoteStoreSpy()
        let sut = NoteLoader(store: store, date: date)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        
        return (sut, store)
    }

}
