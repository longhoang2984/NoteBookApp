//
//  UpdateNoteUseCaseTests.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 02/03/2023.
//

import XCTest
import NoteBookApp

final class UpdateNoteUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receiveMessages, [])
    }
    
    func test_update_hasNoSideEffectOnUpdationNote() {
        let (sut, store) = makeSUT()
        
        let note = uniqueNote()
        try? sut.update(note)
        
        XCTAssertEqual(store.receiveMessages, [.update(note)])
    }
    
    func test_update_failsOnUpdationError() {
        let (sut, store) = makeSUT()
        
        let expectedError = anyError()
        store.completionUpdation(with: expectedError)
        
        do {
            try sut.update(uniqueNote())
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_update_successfullyOnUpdationNote() {
        let (sut, store) = makeSUT()
        
        store.completionUpdationSuccessfully()
        
        do {
            try sut.update(uniqueNote())
        } catch {
            XCTFail("Expected update successfully, got \(error) instead")
        }
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
