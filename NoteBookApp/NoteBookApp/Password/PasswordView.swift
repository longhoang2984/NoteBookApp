//
//  PasswordView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/12/2022.
//

import SwiftUI

struct PasswordView: View {
    
    @State var password: String = ""
    @State var repeatPW: String = ""
    @State var type: InputPasswordType = .create
    
    var body: some View {
        ZStack() {
            mainView
        }
    }
    
    @ViewBuilder
    var mainView: some View {
        switch type {
        case .create:
            createPwView
        case .repeat:
            repeatPwView
        case .input:
            inputPwView
        }
    }
    
    @ViewBuilder
    var createPwView: some View {
        if type == .create {
            InputPasswordView(password: $password, type: $type) { input in
                if input == "delete" {
                    if password.count > 0 {
                        password.removeLast()
                    }
                    print(password)
                } else if password.count < 4 {
                    password += input
                    if password.count == 4 {
                        type = .repeat
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var repeatPwView: some View {
        if type == .repeat {
            InputPasswordView(password: $repeatPW, type: $type) { input in
                if input == "delete" {
                    if repeatPW.count > 0 {
                        repeatPW.removeLast()
                    }
                    print(password)
                } else if repeatPW.count < 4 {
                    repeatPW += input
                    if repeatPW.count == 4 && repeatPW == password {
                        password = ""
                        type = .input
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var inputPwView: some View {
        if type == .input {
            InputPasswordView(password: $password, type: $type) { input in
                if input == "delete" {
                    if password.count > 0 {
                        password.removeLast()
                    }
                    print(password)
                } else if input == "touch" {
                    return
                } else if password.count < 4 {
                    password += input
                }
            }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selectedItem: .password)
    }
}
