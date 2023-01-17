//
//  ImagePicker.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 13/01/2023.
//

import SwiftUI

struct ImagePicker: View {
    @StateObject var imageManager = ImageManager()
    @State var selectedImages: [UIImage] = []
    var onSelectImage: (([UIImage]) -> Void)? = nil
    @Environment(\.dismiss) var pop
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                if !self.imageManager.images.isEmpty {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(imageManager.grid, id: \.self) { index in
                                HStack(spacing: 8) {
                                    ForEach(index..<index+imageManager.numberOfImageInRow, id: \.self) { subIndex in
                                        HStack {
                                            if subIndex < imageManager.images.count {
                                                ImageItem(image: imageManager.images[subIndex], selected: $selectedImages, numberOfImageInRow: imageManager.numberOfImageInRow)
                                            }
                                        }
                                    }
                                    if imageManager.images.count % imageManager.numberOfImageInRow != 0 && index == imageManager.grid.last {
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding([.horizontal], 8)
                    }
                    .padding(.top, 20)
                    
                    FloatingButton(title: "Add") {
                        onSelectImage?(selectedImages)
                        selectedImages.removeAll()
                        pop()
                    }
                    .disabled(selectedImages.count == 0)
                }
            }
        }
        .background(Color.white)
        .onAppear {
            Task {
                await imageManager.fetchingImages()
            }
        }
    }
}

struct ImageItem: View {
    
    @State var image: Images
    @Binding var selected: [UIImage]
    var numberOfImageInRow: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image.image)
                .resizable()
            
            if image.selected {
                ZStack {
                    Color.black.opacity(0.5)
                }
            }
            
            if !image.isCamera {
                VStack {
                    HStack {
                        Spacer()
                        Image(image.selected ? "ic_selected" : "ic_select")
                            .frame(width: 22, height: 16)
                    }
                    Spacer()
                }
                .padding([.trailing, .top], 8)
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 16 - (CGFloat(numberOfImageInRow) - 1) * 8) / CGFloat(numberOfImageInRow), height: (UIScreen.main.bounds.width - 16 - (CGFloat(numberOfImageInRow) - 1) * 8) / CGFloat(numberOfImageInRow))
        .cornerRadius(15)
        .onTapGesture {
            if !image.isCamera {
                if !self.image.selected {
                    image.selected = true
                    selected.append(image.image)
                } else {
                    for i in 0..<selected.count {
                        if selected[i] == self.image.image {
                            selected.remove(at: i)
                            image.selected = false
                            return
                        }
                    }
                }
            }
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker()
    }
}
