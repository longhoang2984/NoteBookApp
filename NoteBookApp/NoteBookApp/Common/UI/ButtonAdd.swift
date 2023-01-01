//
//  ButtonAdd.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/12/2022.
//

import SwiftUI

struct ButtonAdd: View {
    var onTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                onTapped?()
            } label: {
                
                Image("btn_add")
                    .padding(.trailing, 10)
            }
        }
    }
}

struct ButtonAdd_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAdd()
    }
}
