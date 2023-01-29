//
//  PasswordField.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/01/2023.
//

import SwiftUI

public enum PasswordType {
    case primary, confirm
}

struct PasswordField: View {
    @Binding var text: String
    @FocusState var focusState: PasswordType?
    @State var type: PasswordType
    @Binding var current: PasswordType?
    var placeHolder: String = ""
    var submitLabel: SubmitLabel = .return
    var onSubmit: (() -> Void)?
    var shouldMoveLabel: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Text(placeHolder)
                        .foregroundColor(.mischka)
                        .font(.custom("Roboto-Bold", size: shouldMoveLabel ? 10 : 16))
                        .offset(y: shouldMoveLabel ? -15 : 0)
                        .animation(.easeInOut, value: shouldMoveLabel)
                    Spacer()
                }
                
                VStack(spacing: -2) {
                    SecureField("", text: $text)
                    .foregroundColor(.blueOxford)
                    .multilineTextAlignment(.leading)
                    .font(.custom("Roboto-Regular", size: 16))
                    .onSubmit {
                        onSubmit?()
                    }
                    .autocorrectionDisabled()
                    .frame(height: 30)
                    .submitLabel(submitLabel)
                    .focused($focusState, equals: type)
                    .animation(.easeInOut, value: shouldMoveLabel)
                }
            }
            Rectangle()
                .fill(current == type ? Color.bluePrimary : Color.mischka)
                .frame(height: 2)
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(text: .constant("ABC"), type: .primary, current: .constant(.primary)).disabled(true)
    }
}
