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
                            selectedDay: viewModel.selectedDay,
                            eventDateMapper: $viewModel.eventDateMapper,
                            onSelectedDay: { day in
                viewModel.selectedDay = day
            })
        }
        .onAppear {
            Task {
                self.viewModel.getTasks()
            }
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
    public var hasEvent: Bool = true
    @Binding public var eventDateMapper: [Date: Date]
    private var calendarView: HorizonCalendar.CalendarView
    
    public init(startDate: Date = Date.firstDateOfYear(2023),
                endDate: Date = Date.firstDateOfYear(2023).adding(days: 365 * 10),
                isVertical: Bool = true,
                selectedDay: Day? = nil,
                eventDateMapper: Binding<[Date: Date]>,
                onSelectedDay: @escaping (Day) -> Void) {
        self.startDate = startDate
        self.endDate = endDate
        self.isVerital = isVertical
        self.selectedDay = selectedDay
        self.onSelectedDay = onSelectedDay
        self._eventDateMapper = eventDateMapper
        self.calendarView = HorizonCalendar.CalendarView(
            initialContent: Self.makeContent(
                startDate: startDate,
                endDate: endDate,
                isVertical: isVertical,
                selectedDay: selectedDay,
                eventDateMapper: eventDateMapper.wrappedValue))
        
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
                            selectedDay: Day? = nil,
                            eventDateMapper: [Date: Date] = [:]) -> CalendarViewContent {
        return CalendarViewContent(visibleDateRange: startDate...endDate,
                                   monthsLayout: isVertical ? .vertical(options: .init()) : .horizontal(options: .init()))
        .dayItemProvider { day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: UIFont(name: "Roboto-Regular", size: 14) ?? .systemFont(ofSize: 14),
                textColor: UIColor(named: "blue_oxford") ?? .black,
                backgroundColor: .clear
            )
            
            if day == selectedDay {
                invariantViewProperties.backgroundColor = UIColor(named: "blue_secondary") ?? .blue
                invariantViewProperties.textColor = .white
            } else {
                let now = Date.now.startOfDay()
                
                if day.isSameDay(with: now) {
                    invariantViewProperties.backgroundColor = UIColor(named: "gull_gray") ?? .blue
                    invariantViewProperties.textColor = .white
                }
            }
            
            return DayLabel.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                content: .init(day: day, hasEvent: eventDateMapper[day.toDate()] != nil))
        }
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        let content = AppCalendarView.makeContent(
            startDate: startDate,
            endDate: endDate,
            isVertical: isVerital,
            selectedDay: selectedDay,
            eventDateMapper: eventDateMapper)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.calendarView.setContent(content)
            context.coordinator.parent.calendarView.setContent(content)
        }
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
                    selectedDay: day,
                    eventDateMapper: self.parent.eventDateMapper)
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
        let hasEvent: Bool
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayItemView
    {
        return DayItemView(properties: invariantViewProperties)
    }
    
    static func setContent(_ content: Content, on view: DayItemView) {
        view.setContent(content)
    }
    
}

class DayItemView: UILabel {
    let circleView: UIView = UIView()
    
    init(properties: DayLabel.InvariantViewProperties,
         frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpUI(properties: properties)
    }
    
    func setUpUI(properties: DayLabel.InvariantViewProperties) {
        backgroundColor = properties.backgroundColor
        
        font = properties.font
        textColor = properties.textColor
        
        textAlignment = .center
        
        clipsToBounds = true
        layer.cornerRadius = 12
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = UIColor(named: "orange")
        circleView.clipsToBounds = true
        circleView.layer.cornerRadius = 2
        
        addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 4),
            circleView.heightAnchor.constraint(equalToConstant: 4),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 4),
        ])
    }
    
    func setContent(_ content: DayLabel.Content) {
        text = "\(content.day.day)"
        circleView.isHidden = !content.hasEvent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Day {
    func isSameDay(with date: Date) -> Bool {
        let todayComponents = Calendar.current.dateComponents([.year,.month, .day], from: date)
        
        return month.year == todayComponents.year &&  month.month == todayComponents.month && day == todayComponents.day
    }
    
    func toDate() -> Date {
        Calendar.current.date(from: components) ?? .now.startOfDay()
    }
}
