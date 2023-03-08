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
