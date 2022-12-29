//
//  NewPasswordView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/12/2022.
//

import SwiftUI

public enum NewPasswordField {
    case name, login, password, link
}

struct NewPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var item: PasswordItem?
    var onSave: (PasswordItem) -> Void
    @State var id: String = ""
    @State var name: String = ""
    @State var login: String = ""
    @State var password: String = ""
    @State var link: String = ""
    
    @State var nameEditing = false
    @State var loginEditing = false
    @State var passwordEditing = false
    @State var linkEditing = false
    @FocusState var focus: NewPasswordField?
    
    var shouldMoveNameLabel: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.white.ignoresSafeArea()
                
                VStack {
                    InputField(editing: $nameEditing, text: $name, focusState: _focus, field: NewPasswordField.name, placeHolder: "Name", submitLabel: .next, onSubmit: {
                        focus = .login
                    })
                    
                    InputField(editing: $loginEditing, text: $login, focusState: _focus,field: NewPasswordField.login, placeHolder: "Login", submitLabel: .next, onSubmit: {
                        focus = .password
                    })
                    
                    InputField(editing: $passwordEditing, text: $password, focusState: _focus, field: NewPasswordField.password, placeHolder: "Password", submitLabel: .next, onSubmit: {
                        focus = .link
                    })
                    
                    InputField(editing: $linkEditing, text: $link, focusState: _focus, field: NewPasswordField.link, placeHolder: "Link", submitLabel: .next)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button {
                        let item = PasswordItem(id: id, name: name, login: login, password: password, link: link)
                        onSave(item)
                    } label: {
                        Text("Save")
                            .font(.custom("Roboto", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                    }
                    .frame(height: 40)
                    .background(Color("yellow"))
                    .cornerRadius(20)
                    .shadow(radius: 4.0)
                    .padding([.trailing, .bottom], 16)
                }
                
            }.safeAreaInset(edge: .top) {
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("icon_back")
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    
                    Text("Add Password")
                        .font(.custom("Roboto", size: 20))
                        .fontWeight(.bold)
                }
                .background(Color.white)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            id = item?.id ?? UUID().uuidString
            name = item?.name ?? ""
            login = item?.login ?? ""
            password = item?.password ?? ""
            link = item?.link ?? ""
            focus = .name
        }
    }
}

struct InputField: View {
    
    @Binding var editing: Bool
    @Binding var text: String
    @FocusState var focusState: NewPasswordField?
    @State var field: NewPasswordField = .name
    var placeHolder: String = ""
    var submitLabel: SubmitLabel = .return
    var onSubmit: (() -> Void)?
    var shouldMoveLabel: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                HStack {
                    Text(placeHolder)
                        .foregroundColor(.mischka)
                        .font(.custom("Roboto", size: shouldMoveLabel ? 10 : 16))
                        .fontWeight(.bold)
                        .offset(y: shouldMoveLabel ? -15 : 0)
                        .animation(.easeInOut, value: shouldMoveLabel)
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                VStack(spacing: -2) {
                    TextField("", text: $text) { editingChanged in
                        editing = editingChanged
                    }
                    .onSubmit {
                        onSubmit?()
                    }
                    .underlineTextField()
                    .submitLabel(submitLabel)
                    .focused($focusState, equals: field)
                    .animation(.easeInOut, value: shouldMoveLabel)
                }
            }
            Rectangle()
                .fill(editing ? Color.bluePrimary : Color.mischka)
                .frame(height: 2)
                .padding(.horizontal, 16)
        }
    }
}

extension View {
    func underlineTextField() -> some View {
        return self
            .autocorrectionDisabled()
            .padding(.horizontal, 16)
            .frame(height: 40)
    }
}

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordView(item: .init()) { _ in }
    }
}
