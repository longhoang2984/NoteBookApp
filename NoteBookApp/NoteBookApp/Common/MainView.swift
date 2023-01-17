//
//  MainView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/12/2022.
//

import SwiftUI

struct MainView: View {
    @State var selectedItem: TabbarItemType = .home
    @ViewBuilder
    func getView(item: TabbarItemType) -> some View {

            switch selectedItem {
            case .home:
                HomeView()
            case .notes:
                NotesView()
            case .calendar:
                CalendarView()
            case .password:
                PasswordView()
            }   
    }
    
    var body: some View {
        NavigationView {
            MainTabView(selectedItem: $selectedItem, content: getView)
                .ignoresSafeArea()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
