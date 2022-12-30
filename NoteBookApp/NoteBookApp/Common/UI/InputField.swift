//
//  InputField.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 30/12/2022.
//

import SwiftUI

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

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(editing: .constant(false), text: .constant(""))
    }
}
