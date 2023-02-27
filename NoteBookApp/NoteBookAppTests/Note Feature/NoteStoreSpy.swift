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
