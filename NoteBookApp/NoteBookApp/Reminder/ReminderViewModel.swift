//
//  ReminderViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 05/02/2023.
//

import SwiftUI

final class ReminderViewModel: ObservableObject {
    
    @Published var reminderNameEditing: Bool = false
    @Published var reminderName: String = ""
    
    @Published var formatedDate: String = ""
    @Published var showDatePicker: Bool = false
    @Published var selectedDate: Date = .now {
        didSet {
            formatDate()
        }
    }
    
    init() {
        formatDate()
    }
    
    private func formatDate() {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM"
        
        formatedDate = dateFormater.string(from: selectedDate)
    }
    
}
