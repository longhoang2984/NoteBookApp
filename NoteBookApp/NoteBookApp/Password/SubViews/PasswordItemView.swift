//
//  PasswordItemView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/12/2022.
//

import SwiftUI

public struct PasswordItem: Identifiable {
    public let id: String
    public var name: String
    public var login: String
    public var password: String
    public var link: String
    
    
    public init(id: String, name: String, login: String, password: String, link: String) {
        self.id = id
        self.name = name
        self.login = login
        self.password = password
        self.link = link
    }
    
    public init() {
        self.id = UUID().uuidString
        self.name = ""
        self.login = ""
        self.password = ""
        self.link = ""
    }
}

struct PasswordItemView: View {
    
    @Binding var item: PasswordItem
    @State var showing: Bool = false
    var onDeleteItem: ((PasswordItem) -> Void)?
    var onEditItem: ((PasswordItem) -> Void)?
    
    var body: some View {
        Button {
            withAnimation {
                showing.toggle()
            }
        } label: {
            mainView
        }
    }
    
    var mainView: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Text(item.name)
                        .font(.custom("Roboto", size: 16))
                        .foregroundColor(.blueOxford)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image("icon_dropdown")
                        .rotationEffect(.degrees(showing ? -90 : 0))
                    
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 64)
            fullView
        }
        .background(showing ? Color.blueBubble : .white)
        .cornerRadius(10, corners: .allCorners)
        .padding([.horizontal, .bottom], 16)
        .shadow(color: .mischka, radius: 4.0)
    }
    
    @ViewBuilder
    var fullView: some View {
        if showing {
            VStack(alignment: .leading) {
                Text("Login")
                    .smallPasswordItemTitle()
                
                Text(item.login)
                    .smallPasswordItemContent()
                    .padding(.top, 4)
                
                Text("Password")
                    .smallPasswordItemTitle()
                    .padding(.top, 16)
                
                Text(item.password)
                    .smallPasswordItemContent()
                    .padding(.top, 4)
                
                Text("Link")
                    .smallPasswordItemTitle()
                    .padding(.top, 16)
                
                Button {
                    
                } label: {
                    Text(item.link)
                        .font(.custom("Roboto", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.bluePrimary)
                        .underline()
                }
                
                HStack {
                    Spacer()
                    Button {
                        onEditItem?(item)
                    } label: {
                        Image("icon_edit")
                    }
                    
                    Button {
                        onDeleteItem?(item)
                    } label: {
                        Image("icon_delete")
                    }
                    .padding([.leading], 16)
                }
                .padding([.top], 16)
            }
            .padding(16)
        }
    }
}

extension Text {
    func smallPasswordItemTitle() -> Text {
        return self
            .font(.custom("Roboto", size: 12))
            .foregroundColor(.mischka)
            .fontWeight(.bold)
    }
    
    func smallPasswordItemContent() -> Text {
        return self
            .font(.custom("Roboto", size: 14))
            .foregroundColor(.blueOxford)
            .fontWeight(.bold)
    }
}

struct PasswordItemView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordItemView(item: .constant(PasswordItem(id: "", name: "Test", login: "login", password: "123", link: "gmail")))
    }
}
