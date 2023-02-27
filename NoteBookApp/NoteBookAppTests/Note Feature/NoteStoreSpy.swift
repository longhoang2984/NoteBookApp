//
//  NoteStoreSpy.swift
//  NoteBookAppTests
//
//  Created by Cửu Long Hoàng on 27/02/2023.
//

import Foundation
import NoteBookApp

class NoteStoreSpy: NoteStore {
    
    enum ReceivedMessage: Equatable {
        case retrieve
        case insert(_ note: Note)
    }
    
    var receiveMessages: [ReceivedMessage] = []
    
    private var retrivalResult: Result<[Note], Error>?
    private var insertionResult: Result<Void, Error>?
    
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
    
    func insert(_ note: Note) throws {
        receiveMessages.append(.insert(note))
        try insertionResult?.get()
    }
}