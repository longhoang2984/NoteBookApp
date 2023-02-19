//
//  CalendarView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/12/2022.
//

import SwiftUI
import HorizonCalendar

public struct CalendarView: View {
    
    @StateObject var viewModel = CalendarViewModel()
    
    public var body: some View {
        VStack {
            AppCalendarView(startDate: viewModel.startDate,
                            endDate: viewModel.endDate,
                            isVertical: true,
                            selectedDay: viewModel.selectedDay, onSelectedDay: { day in
                viewModel.selectedDay = day
            })
            
            Text("\(viewModel.selectedDay?.description ?? "")")
        }
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

public struct AppCalendarView: UIViewRepresentable {
    
    public var startDate = Date.firstDateOfYear(2023)
    public var endDate = Date.firstDateOfYear(2023).adding(days: 365 * 10)
    public var selectedDay: Day?
    public var onSelectedDay: (Day) -> Void
    public var isVerital: Bool = true
    private var calendarView: HorizonCalendar.CalendarView
    
    public init(startDate: Date = Date.firstDateOfYear(2023),
                endDate: Date = Date.firstDateOfYear(2023).adding(days: 365 * 10),
                isVertical: Bool = true,
                selectedDay: Day? = nil,
                onSelectedDay: @escaping (Day) -> Void) {
        self.startDate = startDate
        self.endDate = endDate
        self.isVerital = isVertical
        self.selectedDay = selectedDay
        self.onSelectedDay = onSelectedDay
        self.calendarView = HorizonCalendar.CalendarView(
            initialContent: Self.makeContent(
                startDate: startDate,
                endDate: endDate,
                isVertical: isVertical,
                selectedDay: selectedDay))
        
        var date = Date.now.startOfDay()
        if let selectedDay = selectedDay, let selectedDate = Calendar.current.date(from: selectedDay.components) {
            date = selectedDate
        }
        self.calendarView.scroll(toMonthContaining: date, scrollPosition: .centered, animated: false)
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }
    
    static func makeContent(startDate: Date,
                            endDate: Date,
                            isVertical: Bool = true,
                            selectedDay: Day? = nil) -> CalendarViewContent {
        return CalendarViewContent(visibleDateRange: startDate...endDate,
                                   monthsLayout: isVertical ? .vertical(options: .init()) : .horizontal(options: .init()))
        .dayItemProvider { day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: UIFont(name: "Roboto-Regular", size: 14) ?? .systemFont(ofSize: 14),
                textColor: UIColor(named: "blue_oxford") ?? .black,
                backgroundColor: .clear)
            
            if day == selectedDay {
                invariantViewProperties.backgroundColor = UIColor(named: "blue_secondary") ?? .blue
                invariantViewProperties.textColor = .white
            } else {
                let now = Date.now.startOfDay()
                let todayComponents = Calendar.current.dateComponents([.year,.month, .day], from: now)
                
                if  day.month.year == todayComponents.year &&  day.month.month == todayComponents.month && day.day == todayComponents.day {
                    invariantViewProperties.backgroundColor = UIColor(named: "gull_gray") ?? .blue
                    invariantViewProperties.textColor = .white
                }
            }
            
            return DayLabel.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                content: .init(day: day))
        }
        
        
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    public class Coordinator: NSObject {
        var parent: AppCalendarView
        
        init(_ parent: AppCalendarView) {
            
            self.parent = parent
            super.init()
            
            parent.calendarView.daySelectionHandler = { [weak self] day in
                guard let self = self else { return }
                self.parent.onSelectedDay(day)
                let content = AppCalendarView.makeContent(
                    startDate: self.parent.startDate,
                    endDate: self.parent.endDate,
                    isVertical: self.parent.isVerital,
                    selectedDay: day)
                self.parent.calendarView.setContent(content)
            }
        }
    }
}

struct DayLabel: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let day: Day
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
    {
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        
        return label
    }
    
    static func setContent(_ content: Content, on view: UILabel) {
        view.text = "\(content.day.day)"
    }
    
}
