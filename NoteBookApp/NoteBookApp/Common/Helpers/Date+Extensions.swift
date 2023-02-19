//
//  Date+Extensions.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 19/02/2023.
//

import Foundation

public extension Date {
    static func firstDateOfYear(_ year: Int) -> Date {
        let calendar = Calendar.current
        
        return calendar.date(from: .init(year: year, month: 1, day: 1))!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar(identifier: .gregorian)
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self)),
                let range = calendar.range(of: .day, in: .month, for: startDate) else { return [self] }
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
    func startOfDay() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        let startOfDay = calendar.startOfDay(for: self)
        return startOfDay.adding(days: 1).adding(seconds: -1)
    }
    
    func isSameDay(with date: Date) -> Bool {
        return self.startOfDay() == date.startOfDay()
    }
}
