//
//  DatePickerPopover.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 06/02/2023.
//

import SwiftUI

struct DatePickerPopover: View {
    @Binding var show: Bool
    @State var date: Date = .now
    var selectedDate: Date?
    @State var currentDate: Date = .now
    @State var selectingDate: Date?
    var startDate: Date?
    var endDate: Date?
    var onSelectedDate: (Date) -> Void
    
    let days: [String] = ["M","T","W","T","F","S","S"]
    @State var month: Int = 0
    @State var year: Int = 0
    
    func isDateInRange(_ date: Date) -> Bool {
        var isInRange = true
        
        if let startDate = startDate, let endDate = endDate {
            isInRange = date >= startDate && date <= endDate
        } else if let startDate = startDate {
            isInRange = date >= startDate
        } else if let endDate = endDate {
            isInRange = date <= endDate
        }
        
        return isInRange
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            
            HStack {
                Button {
                    withAnimation {
                        self.month -= 1
                    }
                } label: {
                    Image("btn_previous")
                        .renderingMode(.template)
                }
                .buttonStyle(OrangeButtonStyle())
                
                Text(getMonthYear().capitalized)
                    .font(.custom("Roboto-Regular", size: 20))
                    .foregroundColor(.gullGray)
                
                Button {
                    withAnimation {
                        self.month += 1
                    }
                } label: {
                    Image("btn_next")
                        .renderingMode(.template)
                }
                .buttonStyle(OrangeButtonStyle())
            }
            .padding(.bottom, 10)
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns) {
                ForEach(days.indices, id: \.self) { index in
                    Text(days[index])
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gullGray)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { item in
                    cardView(item: item)
                }
            }
            
            HStack(spacing: 20) {
                Spacer()
                Button {
                    show.toggle()
                } label: {
                    Text("CANCEL")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gullGray)
                }
                .frame(width: 60)
                
                Button {
                    guard let selectingDate = selectingDate else { return }
                    onSelectedDate(selectingDate)
                    show.toggle()
                } label: {
                    Text("OK")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(selectingDate != nil ? .blueSecondary : .mischka)
                }
                .frame(width: 60)


            }

        }
        .popoverShadow(shadow: .system)
        .padding(20)
        .background(.white)
        .scaleEffect(!show ? 2 : 1)
        .opacity(!show ? 0 : 1)
        .cornerRadius(16)
        .shadow(radius: 2.0)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {
                if let selectedDate = selectedDate {
                    currentDate = selectedDate
                } else {
                    currentDate = getCurrentMonth()
                }
                
                selectingDate = currentDate
            }
        }
        .onChange(of: month) { newValue in
            currentDate = getCurrentMonth()
        }
    }
    
    func cardView(item: DateItem) -> some View {
        
        var dateLabelColor: Color = isDateInRange(item.date) ? .gullGray : .mischka
        var dateBackgroundColor = Color.clear
        if (selectingDate?.isSameDay(with: item.date) == true || Date.now.isSameDay(with: item.date)) && item.day != -1 {
            dateLabelColor = Color.white
            
            if Date.now.isSameDay(with: item.date) {
                dateBackgroundColor = .gullGray
            }
            
            if selectingDate?.isSameDay(with: item.date) == true {
                dateBackgroundColor = .blueSecondary
            }
        }
        
        
        return Button(action: {
            if isDateInRange(item.date) {
                selectingDate = item.date
            }
        }, label: {
            VStack {
                if item.day != -1 {
                    Text("\(item.day)")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(dateLabelColor)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(dateBackgroundColor)
                        }
                }
            }
        })
        .padding(.vertical, 8)
        .frame(width: 40, height: 40, alignment: .center)
        
    }
    
    func getMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        
        return dateFormatter.string(from: currentDate)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        guard let month = calendar.date(byAdding: .month, value: self.month, to: selectedDate ?? Date()) else { return .now }
        
        return month
    }
    
    func extractDate() -> [DateItem] {
        let calendar = Calendar(identifier: .gregorian)
        let month = currentDate
        
        var days = month.getAllDates().compactMap { date -> DateItem in
            let day = calendar.component(.day, from: date)
            
            return DateItem(day: day, date: date)
        }
        
        var firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        if firstWeekday == 1 {
            firstWeekday = 8
        }
        
        for _ in 1..<firstWeekday - 1 {
            days.insert(DateItem(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

struct DatePickerPopover_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerPopover(show: .constant(true), selectedDate: Date.now.adding(days: 31),
                          startDate: Date().startOfDay(),
                          endDate: Date().adding(days: 360).endOfDay(),
                          onSelectedDate: { _ in })
    }
}

struct DateItem: Identifiable {
    let id: String = UUID().uuidString
    var day: Int
    var date: Date
}

extension Date {
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
