//
//  PhotoListView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 17/01/2023.
//

import SwiftUI

struct PhotoListView: View {
    var images: [UIImage] = []
    var isViewing: Bool = false
    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 137.5, height: 137.5)
    var onRemoveImageAtIndex: ((Int) -> Void)?
    
    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
            ForEach(images, id: \.self) { img in
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.itemSize.width, height: Self.itemSize.height)
                    .cornerRadius(Self.itemCornerRadius)
                    .overlay(alignment: .topTrailing) {
                        if !isViewing {
                            Button {
                                if let index = images.firstIndex(of: img) {
                                    onRemoveImageAtIndex?(index)
                                }
                            } label: {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .background {
                                        Color.white.opacity(0.5)
                                    }
                                    .cornerRadius(10)
                            }
                            .frame(width: 40, height: 40)
                        }
                    }
                    .shadow(color: .mischka, radius: 4.0)
            }
        }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
