//
//  FloatingButton.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

import SwiftUI

public struct FloatingButton: View {
    var title: String
    var onTapped: (() -> Void)?
    
    public init(title: String, onTapped: (() -> Void)? = nil) {
        self.title = title
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped?()
        } label: {
            Text(title)
                .font(.custom("Roboto", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical)
                .padding(.horizontal, 20)
                .frame(height: 45)
                .background(Color.appYellow)
                .cornerRadius(45 / 2)
                .shadow(color: Color.mischka, radius: 4.0)
        }
        .padding(.trailing, 16)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(title: "Save")
    }
}
