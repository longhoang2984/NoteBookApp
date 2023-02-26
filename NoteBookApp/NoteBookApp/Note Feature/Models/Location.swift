//
//  Location.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/02/2023.
//

import Foundation

public struct Location: Hashable {
    public let id: UUID
    public let name: String
    public let lat: Double
    public let lng: Double
    
    public init(id: UUID,
                name: String,
                lat: Double,
                lng: Double) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}
