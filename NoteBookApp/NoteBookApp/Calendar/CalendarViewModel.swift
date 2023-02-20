//
//  CalendarViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 19/02/2023.
//

import Foundation
import SwiftUI
import HorizonCalendar

public class CalendarViewModel: ObservableObject {
    
    @Published var selectedDay: Day?
    @Published var showVerticalCalendar: Bool = true
    @Published var eventDateMapper: [Date: Date] = [:]
    let startDate = Date.now.startOfDay()
    let endDate = Date.now.startOfDay().adding(days: 365 * 10)
    
    func getTasks() {
        eventDateMapper = [.now.startOfDay(): .now.startOfDay(),
                                          .now.adding(days: 3).startOfDay(): .now.adding(days: 3).startOfDay()]
    }
}
