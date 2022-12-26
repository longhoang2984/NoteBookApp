//
//  HomeView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 25/12/2022.
//

import SwiftUI

struct HomeView: View {
    
    @State var toDoItems: [ItemViewModel] = [
        ItemViewModel(id: UUID().uuidString, title: "Shopping", images: ["ic_home_location_thumb", "ic_home_audio_thumb", "ic_home_audio_thumb"], deadline: "today", deadlineIcon: "icon_deadline"),
        ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline"),
        ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline"),
        ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("blue_light")
                .edgesIgnoringSafeArea(.all)
            
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading) {
                    headerView
                    reminderView
                    toDoListsView
                    HStack {
                        Spacer()
                    }
                    .frame(height: 150)
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Image("btn_add")
                        .padding(.bottom, 80)
                        .padding(.trailing, 20)
                }
            }
            
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .trailing) {
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
    
    private var reminderView: some View {
        VStack(alignment: .leading) {
            Text("Reminder")
                .fontWeight(.bold)
                .font(.subheadline)
                .foregroundColor(Color("gull_gray"))
                .padding(.bottom, 8)
            
            ForEach(0..<2) { _ in
                reminderItemView
            }
        }
        .padding([.leading, .trailing, .top], 25)
    }
    
    private var reminderItemView: some View {
        Button {
            
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
    
    private var toDoListsView: some View {
        VStack(alignment: .leading) {
            Text("To-do-lists")
                .fontWeight(.bold)
                .font(.subheadline)
                .foregroundColor(Color("gull_gray"))
                .padding(.bottom, 8)
            
            toDoListItems
        }
        .padding([.leading, .trailing, .top], 25)
    }
    
    private var toDoListItems: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 13) {
                ForEach($toDoItems, id: \.self) { item in
                    Button {
                        
                    } label: {
                        CardItemView(item: item)
                            .frame(
                                width: 116,
                                height: 144
                            )
                    }
                    
                }
            }
            .frame(height: 160)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

