//
//  MainTabbar.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 25/12/2022.
//

import SwiftUI

public enum TabbarItemType {
    case home
    case notes
    case calendar
    case password
    
    static var allCases: [TabbarItemType] {
        return [.home, .notes, .calendar, .password]
    }
    
    static var tabbarItems: [TabbarItem] {
        TabbarItemType.allCases.map { $0.tabbarItem }
    }
    
    var tabbarItem: TabbarItem {
        switch self {
        case .home:
            return TabbarItem(title: "Home", image: Image("home_icon"))
        case .notes:
            return TabbarItem(title: "Notes", image: Image("note_icon"))
        case .calendar:
            return TabbarItem(title: "Calendar", image: Image("calendar_icon"))
        case .password:
            return TabbarItem(title: "Password", image: Image("password_icon"))
        }
    }
}

struct MainTabView<Content: View>: View {
    
    let tabbarItems: [TabbarItemType] = TabbarItemType.allCases
    
    @Binding var selectedItem: TabbarItemType
    @ViewBuilder var content: (TabbarItemType) -> Content
    @Binding var showTabBar: Bool
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedItem) {
                ForEach(tabbarItems, id: \.self) { item in
                    content(item)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            tabBar
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground() // 🔑
            appearance.backgroundColor = .clear
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    @ViewBuilder
    var tabBar: some View {
        if showTabBar {
            VStack {
                CustomTabView(tabbarItems: tabbarItems, selectedItem: $selectedItem)
                    .ignoresSafeArea()
            }
            .background {
                Color.clear
            }
        }
    }
}

struct CustomTabView: View {
    let tabbarItems: [TabbarItemType]
    
    @Binding var selectedItem: TabbarItemType
    
    var body: some View {
        HStack {
            ForEach(tabbarItems, id: \.self) { item in
                TabbarItemView(item: item, selectedItem: $selectedItem)
            }
        }
        .padding(.all)
        .background(.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 4.0)
    }
}

struct MainTabbar_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct TabbarItem: Identifiable {
    let id = UUID()
    
    var title: String
    var image: Image
}

struct TabbarItemView: View {
    
    var item: TabbarItemType
    @Binding var selectedItem: TabbarItemType
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                withAnimation {
                    selectedItem = item
                }
            } label: {
                VStack {
                    item.tabbarItem.image
                        .scaleEffect(item == selectedItem ? 0.001 : 1)
                        .offset(y: item == selectedItem ? 0 : 10)
                        .opacity(item == selectedItem ? 0 : 1)
                    Text(item.tabbarItem.title)
                        .font(.custom("Roboto", size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(Color("blue_oxford"))
                        .offset(y: item == selectedItem ? -20 : 0)
                        .opacity(item == selectedItem ? 1 : 0)
                    Circle()
                        .fill(Color("orange"))
                        .frame(width: 5, height: 5)
                        .offset(y: item == selectedItem ? -20 : 0)
                        .opacity(item == selectedItem ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 50)
    }
}
