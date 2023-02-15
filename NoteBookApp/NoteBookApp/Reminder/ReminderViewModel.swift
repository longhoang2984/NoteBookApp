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
    
    @Published var formatedTime: String = "23:00"
    @Published var showTimePicker: Bool = false
    
    @Published var noteContent: String = ""
    @Published var height: CGFloat = 40
    @Published var isNoteEditing: Bool = false
    
    init() {
        formatDate()
    }
    
    private func formatDate() {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM"
        
        formatedDate = dateFormater.string(from: selectedDate)
    }
    
}
