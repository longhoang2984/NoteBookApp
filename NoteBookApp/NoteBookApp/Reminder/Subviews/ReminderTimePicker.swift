//
//  ReminderTimePicker.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 15/02/2023.
//

import SwiftUI

struct ReminderTimePicker: View {
    @Binding var show: Bool
    var timeString: String
    @State var time: Int = 9
    @State var minute: Int = 0
    var onSelectedTime: (String) -> Void
    let maxTime = 23
    let maxMinute = 55
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center) {
                VStack (spacing: 0) {
                    Button {
                        if time < maxTime {
                            time += 1
                        } else {
                            time = 0
                        }
                    } label: {
                        Image("btn_up_gray")
                            .renderingMode(.template)
                    }
                    .buttonStyle(OrangeButtonStyle())
                    
                    Text(
                        String(format: "%02d", time)
                    )
                    .font(.custom("Roboto-Medium", size: 50))
                    .foregroundColor(.blueOxford)
                    
                    Button {
                        if time > 0 {
                            time -= 1
                        } else {
                            time = maxTime
                        }
                    } label: {
                        Image("btn_down_gray")
                            .renderingMode(.template)
                    }
                    .buttonStyle(OrangeButtonStyle())
                }
                
                VStack {
                    Text(":")
                    .font(.custom("Roboto-Medium", size: 50))
                    .foregroundColor(.blueOxford)
                }
                .padding(.bottom, 10)
                
                VStack(spacing: 0) {
                    Button {
                        
                        if minute < maxMinute {
                            minute += 5
                        } else {
                            minute = 0
                        }
                    } label: {
                        Image("btn_up_gray")
                            .renderingMode(.template)
                    }
                    .buttonStyle(OrangeButtonStyle())
                    
                    Text(
                        String(format: "%02d", minute)
                    )
                    .font(.custom("Roboto-Medium", size: 50))
                    .foregroundColor(.blueOxford)
                    
                    Button {
                        if minute > 0 {
                            minute -= 5
                        } else {
                            minute = maxMinute
                        }
                    } label: {
                        Image("btn_down_gray")
                            .renderingMode(.template)
                    }
                    .buttonStyle(OrangeButtonStyle())
                }
            }
            
            HStack {
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
                        onSelectedTime(String(format: "%02d:%02d", time, minute))
                        show.toggle()
                    } label: {
                        Text("OK")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.blueSecondary)
                    }
                    .frame(width: 60)
                }
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
                let timeSplit = timeString.split(separator: ":")
                time = Int(timeSplit[0]) ?? 9
                minute = Int(timeSplit[1]) ?? 0
            }
        }
    }
}

struct ReminderTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        ReminderTimePicker(show: .constant(true), timeString: "09:00", onSelectedTime: { _ in })
    }
}
