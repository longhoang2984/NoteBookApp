//
//  PhotoItemView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 18/01/2023.
//

import SwiftUI
import Photos

struct PhotoItemView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var imageSize: CGSize
    var onImageTapped: (() -> Void)?
    
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    static let cachingImageSize = PHImageManagerMaximumSize

    var body: some View {
        
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.7)
            }
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result, let img = result.image {
                        self.image = Image(uiImage: img)
                    }
                }
            }
        }
    }
}
