//
//  PasswordListView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/12/2022.
//

import SwiftUI

struct PasswordListView: View {
    @FocusState private var isFocused: Bool
    @State var isSearching: Bool = false
    @State var keywordSearching = ""
    @State var items = [
        PasswordItem(id: UUID().uuidString, name: "Credit Card PIN", login: "123-456-789", password: "12345", link: "vpbank.com.vn"),
        PasswordItem(id: UUID().uuidString, name: "Mail Password", login: "mama@gamil.com", password: "12345", link: "gmail.com"),
        PasswordItem(id: UUID().uuidString, name: "Instagram Password", login: "mama@gmail.com", password: "12345", link: "instagram.com"),
        PasswordItem(id: UUID().uuidString, name: "Credit Card PIN", login: "123-456-789", password: "12345", link: "vpbank.com.vn"),
        PasswordItem(id: UUID().uuidString, name: "Mail Password", login: "mama@gamil.com", password: "12345", link: "gmail.com"),
        PasswordItem(id: UUID().uuidString, name: "Instagram Password", login: "mama@gmail.com", password: "12345", link: "instagram.com"),
        PasswordItem(id: UUID().uuidString, name: "Credit Card PIN", login: "123-456-789", password: "12345", link: "vpbank.com.vn"),
        PasswordItem(id: UUID().uuidString, name: "Mail Password", login: "mama@gamil.com", password: "12345", link: "gmail.com"),
        PasswordItem(id: UUID().uuidString, name: "Instagram Password", login: "mama@gmail.com", password: "12345", link: "instagram.com"),
        PasswordItem(id: UUID().uuidString, name: "Credit Card PIN", login: "123-456-789", password: "12345", link: "vpbank.com.vn"),
        PasswordItem(id: UUID().uuidString, name: "Mail Password", login: "mama@gamil.com", password: "12345", link: "gmail.com"),
        PasswordItem(id: UUID().uuidString, name: "Instagram Password", login: "mama@gmail.com", password: "12345", link: "instagram.com"),
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.blueLight.ignoresSafeArea()
            
            ScrollView {
                ForEach($items, id: \.self.id) { item in
                    PasswordItemView(item: item)
                }
                HStack {
                    Spacer()
                }
                .frame(height: 100)
            }
            ButtonAdd {
                print("onTapped")
            }
        }.safeAreaInset(edge: .top) {
            HStack {
                headerView
                    .padding()
            }
            .background(Color.blueLight)
            .shadow(radius: 0)
        }
    }
    
    @ViewBuilder
    var headerView: some View {
        if !isSearching {
            ZStack(alignment: .center) {
                Text("Password")
                    .foregroundColor(.blueOxford)
                    .font(.custom("Roboto", size: 20))
                    .fontWeight(.bold)
                    .opacity(isSearching ? 0 : 1)
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isSearching.toggle()
                            isFocused = true
                        }
                    } label: {
                        Image("ic_search")
                    }
                }
            }
            
        } else {
            HStack {
                Image("ic_search")
                TextField("Enter the note title", text: $keywordSearching) {
                    
                }
                .focused($isFocused)
                .accentColor(.blueOxford)
                .foregroundColor(.blueOxford)
            }
        }
    }
}

struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView()
    }
}
