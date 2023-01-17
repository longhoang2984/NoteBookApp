//
//  PhotoListView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 17/01/2023.
//

import SwiftUI

struct PhotoListView: View {
    var images: [UIImage] = []
    
    var body: some View {
        LazyVGrid(columns: [GridItem](repeating: GridItem(.fixed((UIScreen.main.bounds.width - 60) / 2)), count: 2), spacing: 10) {
            ForEach(images, id: \.self) { img in
                Image(uiImage: img)
                    .resizable()
                    .frame(width: (UIScreen.main.bounds.width - 60) / 2, height: (UIScreen.main.bounds.width - 60) / 2)
                    .cornerRadius(15)
            }
        }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
