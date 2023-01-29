//
//  PasswordDialog.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/01/2023.
//

import SwiftUI
import Popovers

struct PasswordDialog: View {
    @State var password: String = ""
    @State var confirmPW: String = ""
    @Binding var show: Bool
    @FocusState var focus: PasswordType?
    @State var currentFocus: PasswordType? = PasswordType.primary
    var onSubmit: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Block note")
                .font(.custom("Roboto-Medium", size: 20))
            
            HStack {
                Spacer()
            }
            .frame(height: 22)
            
            PasswordField(text: $password, focusState: _focus, type: .primary, current: $currentFocus, placeHolder: "Password") {
                currentFocus = .confirm
            }
                .onTapGesture {
                    currentFocus = .primary
                }
            PasswordField(text: $confirmPW, focusState: _focus, type: .confirm,  current: $currentFocus, placeHolder: "Confirm") {
                currentFocus = nil
            }
                .onTapGesture {
                    currentFocus = .confirm
                }
            
            HStack {
                Spacer()
            }
            .frame(height: 22)
            
            HStack {
                Spacer()
                
                Button {
                    show.toggle()
                } label: {
                    Text("CANCEL")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.mischka)
                }
                
                Button {
                    onSubmit(password)
                } label: {
                    Text("BLOCK")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(!password.isEmpty && !confirmPW.isEmpty && password == confirmPW ? .blueSecondary : .gullGray)
                        .disabled(!password.isEmpty && !confirmPW.isEmpty && password == confirmPW)
                }
            }
        }
        .onChange(of: currentFocus, perform: { newValue in
            focus = currentFocus
        })
        .popoverShadow(shadow: .system)
        .padding(32)
        .background(.white)
        .scaleEffect(!show ? 2 : 1)
        .opacity(!show ? 0 : 1)
        .cornerRadius(16)
        .shadow(radius: 2.0)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {

            }
        }
        .onAppear {
            focus = currentFocus
        }
    }
}

struct PasswordDialog_Previews: PreviewProvider {
    static var previews: some View {
        PasswordDialog(show: .constant(true), onSubmit: { _ in })
    }
}
