//
//  HomeViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 30/01/2023.
//

import Foundation

public class HomeViewModel: ObservableObject {
    @Published var showAddMenu: Bool = false
    @Published var showAddNewNote: Bool = false
}
