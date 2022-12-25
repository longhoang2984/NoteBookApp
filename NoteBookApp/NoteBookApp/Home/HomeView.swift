//
//  HomeView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 25/12/2022.
//

import SwiftUI

struct HomeView: View {
    fileprivate func headerView() -> some View {
        return VStack(alignment: .trailing) {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Text ("MONDAY")
                            .foregroundColor(Color("blue_oxford"))
                            .fontWeight(.bold)
                            .padding(.top, 16)
                            .padding(.trailing, 25)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Spacer()
                        Text("Sept, 15")
                            .foregroundColor(Color("blue_oxford"))
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .padding(.bottom, 16)
                            .padding(.trailing, 25)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .frame(
                    width: 236,
                    height: 96
                )
                .background {
                    Color.white
                }
                .cornerRadius(96 / 2, corners: [.topLeft, .bottomLeft])
            }
        }
        .padding(.top, 60)
    }
    
    fileprivate func reminderItemView() -> some View {
        return Button {
            
        } label: {
            HStack(alignment: .center, spacing: 16) {
                Text("9:00")
                    .fontWeight(.bold)
                    .font(.subheadline)
                
                Text("Feed the cat")
                    .fontWeight(.bold)
                    .font(.subheadline)
                
                Spacer()
                
                Image("ic_bell")
                    .renderingMode(.template)
                
            }
            .padding([.leading, .trailing], 24)
            .frame(
                height: 56
            )
        }
        .buttonStyle(BlueButtonStyle())
        .cornerRadius(56 / 2)
        .shadow(color: Color("mischka"), radius: 4.0)
    }
    
    fileprivate func reminderView() -> some View {
        return VStack(alignment: .leading) {
            Text("Reminder")
                .fontWeight(.bold)
                .font(.subheadline)
                .foregroundColor(Color("gull_gray"))
                .padding(.bottom, 8)
            
            ForEach(0..<2) { _ in
                reminderItemView()
            }
        }
        .padding([.leading, .trailing, .top], 25)
    }
    
    fileprivate func toDoListItems() -> some View {
        return ScrollView(.horizontal) {
            HStack() {
                ForEach(0..<3) { _ in
                    Button {
                        
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Shopping")
                                .font(.custom("Roboto", size: 16))
                                .fontWeight(.medium)
                                .foregroundColor( Color("blue_oxford"))
                            HStack {
                                Image("ic_home_location_thumb")
                                
                                Image("ic_home_audio_thumb")
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Image("icon_deadline")
                                Text("today")
                                    .font(.custom("Roboto", size: 10))
                                    .foregroundColor(Color("blue_secondary"))
                            }
                        }
                        .padding(.all, 10)
                    }
                    .frame(
                        width: 116,
                        height: 144
                    )
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: Color("mischka"), radius: 2.0, y: 4)
                }
            }
        }
    }
    
    fileprivate func toDoListsView() -> some View {
        return VStack(alignment: .leading) {
            Text("To-do-lists")
                .fontWeight(.bold)
                .font(.subheadline)
                .foregroundColor(Color("gull_gray"))
                .padding(.bottom, 8)
            
            toDoListItems()
                .frame(height: 149)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("blue_light")
                .edgesIgnoringSafeArea(.all)
            
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Image("btn_add")
                        .padding(.bottom, 40)
                        .padding(.trailing, 20)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    headerView()
                    reminderView()
                    toDoListsView()
                        .padding([.leading, .trailing, .top], 25)
                }
            }
            
        }
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .white : Color("blue_oxford"))
            .background(configuration.isPressed ? Color("blue_secondary") : .white)
            
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

