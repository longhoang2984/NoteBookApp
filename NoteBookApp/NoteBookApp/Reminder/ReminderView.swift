//
//  ReminderView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 05/02/2023.
//

import SwiftUI

struct ReminderView: View {
    @StateObject var model = ReminderViewModel()
    @Environment(\.dismiss) var pop
    
    var body: some View {
        VStack {
            InputField(editing: $model.reminderNameEditing, text: $model.reminderName, placeHolder: "Name")
            
            SelectionField(icon: "ic_deadline_gray", title: "Date", content: $model.formatedDate) {
                model.showDatePicker.toggle()
            }
            
            SelectionField(icon: "ic_time_gray", title: "Time", content: $model.formatedTime) {
                model.showTimePicker.toggle()
            }
            
            Spacer()
        }
        .padding(.vertical)
        .safeAreaInset(edge: .top) {
            header
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                FloatingButton(title: "SAVE")
            }
        }
        .popover(present: $model.showDatePicker, attributes: {
            $0.blocksBackgroundTouches = true
            $0.rubberBandingMode = .none
            $0.position = .relative(
                popoverAnchors: [
                    .center,
                ]
            )
            $0.presentation.animation = .easeOut(duration: 0.15)
            $0.dismissal.mode = .none
            $0.onTapOutside = {
                model.showDatePicker.toggle()
            }
        }) {
            DatePickerPopover(show: $model.showDatePicker, selectedDate: model.selectedDate) { date in
                model.selectedDate = date
            }
        } background: {
            Color.black.opacity(0.7)
        }
        .popover(present: $model.showTimePicker, attributes: {
            $0.blocksBackgroundTouches = true
            $0.rubberBandingMode = .none
            $0.position = .relative(
                popoverAnchors: [
                    .center,
                ]
            )
            $0.presentation.animation = .easeOut(duration: 0.15)
            $0.dismissal.mode = .none
            $0.onTapOutside = {
                model.showTimePicker.toggle()
            }
        }) {
            ReminderTimePicker(show: $model.showTimePicker, timeString: model.formatedTime) { time in
                model.formatedTime = time
            }
        } background: {
            Color.black.opacity(0.7)
        }

    }
    
    var header: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        pop()
                    } label: {
                        Image("icon_back")
                    }
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("Reminder")
                                .font(.custom("Roboto", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.blueOxford)
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
            .background(Color.white)
        }
        
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}

public extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
