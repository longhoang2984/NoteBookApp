//
//  MainTabbar.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 25/12/2022.
//

import SwiftUI

struct MainTabbar: View {
    
    let tabbarItems: [TabbarItem] = [
        TabbarItem(title: "Home", image: Image("home_icon")),
        TabbarItem(title: "Notes", image: Image("note_icon")),
        TabbarItem(title: "Calendar", image: Image("calendar_icon")),
        TabbarItem(title: "Password", image: Image("password_icon")),
    ]
    
    @Binding var selectedItemTitle: String
    
    var body: some View {
        HStack {
            ForEach(tabbarItems, id: \.title) { item in
                TabbarItemView(item: item, selectedItemTitle: $selectedItemTitle)
            }
        }
        .padding(.all)
        .background(.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

struct MainTabbar_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct TabbarItem: Identifiable {
    let id = UUID()
    
    var title: String
    var image: Image
}

struct TabbarItemView: View {
    
    var item: TabbarItem
    @Binding var selectedItemTitle: String
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                withAnimation {
                    selectedItemTitle = item.title
                }
            } label: {
                if item.title == selectedItemTitle {
                    VStack {
                        Text(item.title)
                            .font(.custom("Roboto", size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color("blue_oxford"))
                        
                        Circle()
                            .fill(Color("orange"))
                            .frame(width: 4, height: 4)
                    }
                } else {
                    item.image
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 50)
    }
}
