//
//  DeleteNoteUseCaseTests.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 07/03/2023.
//

import XCTest
import NoteBookApp

final class DeleteNoteUseCaseTests: XCTestCase {

    func test_does_notMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receiveMessages, [])
    }
    
    func test_delete_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        
        let expectedError = anyError()
        store.completionDeletion(with: expectedError)
        do {
            try sut.delete(uniqueNote())
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_delete_successfullyOnDeletionNote() {
        let (sut, store) = makeSUT()
        
        store.completionDeletionSuccessfully()
        do {
            try sut.delete(uniqueNote())
        } catch {
           XCTFail("Expected delete successfully, got \(error) instead")
        }
    }
    
    func test_delete_hasNoSideEffectOnDeletionNote() {
        let (sut, store) = makeSUT()
        
        try? sut.delete(uniqueNote())
        
        XCTAssertEqual(store.receiveMessages, [.delete(uniqueNote())])
    }
    
    // MARK: - Helpers
    private func makeSUT(date: @escaping () -> Date = Date.init,file: StaticString = #file, line: UInt = #line) -> (sut: NoteLoader, store: NoteStoreSpy) {
        let store = NoteStoreSpy()
        let sut = NoteLoader(store: store, date: date)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        
        return (sut, store)
    }
}
