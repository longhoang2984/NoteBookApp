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
    
    private func makeSUT(date: @escaping () -> Date = Date.init,file: StaticString = #file, line: UInt = #line) -> (sut: NoteLoader, store: NoteStoreSpy) {
        let store = NoteStoreSpy()
        let sut = NoteLoader(store: store, date: date)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        
        return (sut, store)
    }

}
