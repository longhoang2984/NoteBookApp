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
    let startDate = Date.now.startOfDay()
    let endDate = Date.now.startOfDay().adding(days: 365 * 10)
    
}
