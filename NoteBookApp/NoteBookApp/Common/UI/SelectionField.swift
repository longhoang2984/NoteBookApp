//
//  DatePickerView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 05/02/2023.
//

import SwiftUI

struct SelectionField: View {
    var icon: String
    var title: String
    @Binding var content: String
    var onSelected: () -> Void
    
    var body: some View {
        Button {
            onSelected()
        } label: {
            VStack {
                HStack(spacing: 12) {
                    Image(icon)
                    
                    Text(title)
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(.gullGray)
                    
                    Spacer()
                    
                    Text(content)
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(.blueOxford)
                }
                
                Rectangle()
                    .fill( Color.mischka)
                    .frame(height: 2)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct SelectionField_Previews: PreviewProvider {
    static var previews: some View {
        SelectionField(icon: "ic_deadline_gray", title: "Date", content: .constant("03 June"), onSelected: {})
    }
}
