//
//  ImagePicker.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 13/01/2023.
//

import SwiftUI

struct ImagePicker: View {
    @StateObject var imageManager = ImageManager()
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
            }
        }
        .background(Color.white)
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker()
    }
}
