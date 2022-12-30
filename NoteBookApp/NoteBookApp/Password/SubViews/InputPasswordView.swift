//
//  CreateNewPassword.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/12/2022.
//

import SwiftUI

public enum InputPasswordType {
    case create
    case `repeat`
    case input
}

struct InputPasswordView: View {
    
    @Binding var password: String
    @Binding var type: InputPasswordType
    var onButtonPressed: (String) -> Void
    
    var inputs: [String] = ["1", "2", "3",
                           "4", "5", "6",
                           "7", "8", "9",
                           "touch", "0", "delete"]
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                headerView
                    .frame(minHeight: 70)
                
                HStack {
                    Spacer()
                }
                .frame(height: 30)
                
                HStack(spacing: 26) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(index <= (password.count - 1) ? Color.blueSecondary : Color.white)
                            .frame(width: 14, height: 14)
                            .background(
                                Circle()
                                    .stroke(Color.blueSecondary, lineWidth: 1)
                            )
                    }
                }
                
                HStack {
                    Spacer()
                }
                .frame(height: 60)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 30) {
                    ForEach(inputs, id: \.self) { input in
                        Button {
                            onButtonPressed(input)
                        } label: {
                            passwordImageButton(input: input)
                                .frame(width: 61, height: 61)
                        }
                        .buttonStyle(PasswordButtonStyle())
                        .cornerRadius(61 / 2)
                    }
                }
                
                Spacer()
            
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var headerView: some View {
        switch type {
            
        case .create:
            createPWHeaderView
        case .repeat:
            repeatPWHeaderView
        case .input:
            enterPWHeaderView
        }
    }
    
    @ViewBuilder
    var createPWHeaderView: some View {
        VStack {
            Text("Create new password")
                .font(.custom("Roboto", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.blueOxford)
            
            Text("Please create new password\nto protect you data in future")
                .foregroundColor(.mischka)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
        }
    }
    
    @ViewBuilder
    var repeatPWHeaderView: some View {
        VStack {
            Text("Repeat new password")
                .font(.custom("Roboto", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.blueOxford)
            
            Text("Please repeat new password")
                .foregroundColor(.mischka)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
        }
    }
    
    @ViewBuilder
    var enterPWHeaderView: some View {
        VStack {
            Text("Enter your password")
                .font(.custom("Roboto", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.blueOxford)
        }
    }
    
    @ViewBuilder
    func passwordImageButton(input: String) -> some View {
        if input != "touch" {
            Image(input)
                .renderingMode(Int(input) != nil ? .template : .original)
        } else if type == .input {
            Image(input)
                .renderingMode(Int(input) != nil ? .template : .original)
        }
    }
}

struct CreateNewPassword_Previews: PreviewProvider {
    static var previews: some View {
        InputPasswordView(password: .constant(""), type: .constant(.create), onButtonPressed: { _ in })
    }
}

struct PasswordButtonStyle: ButtonStyle {
    var ignoreBackgroundOnPressed = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .blueSecondary : .blueOxford)
            .background(configuration.isPressed && !ignoreBackgroundOnPressed ? Color.blueLight : .white)
            
    }
}
