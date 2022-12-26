//
//  BlueButtonStyle.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/12/2022.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .white : Color("blue_oxford"))
            .background(configuration.isPressed ? Color("blue_secondary") : .white)
            
    }
}
