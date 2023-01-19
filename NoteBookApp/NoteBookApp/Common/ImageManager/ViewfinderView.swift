//
//  ViewfinderView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 18/01/2023.
//

import SwiftUI

struct ViewfinderView: View {
    @Binding var image: Image?
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .padding(.top, 50)
            }
            Spacer()
        }
    }
}

struct ViewfinderView_Previews: PreviewProvider {
    static var previews: some View {
        ViewfinderView(image: .constant(Image(systemName: "pencil")))
    }
}

