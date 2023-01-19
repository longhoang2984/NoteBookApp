//
//  PhotoCollectionView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 18/01/2023.
//

import SwiftUI
import os.log

struct PhotoCollectionView: View {
    @State var selectedImages: [PhotoAsset] = []
    var onSelectImage: (([UIImage]) -> Void)? = nil
    @State var showCameraView: Bool = false
    @Environment(\.dismiss) var pop
    @StateObject private var model = CameraViewModel(saveSquareImage: true)
    
    @Environment(\.displayScale) private var displayScale
    let cache = CachedImageManager()
    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 90, height: 90)
    private static let bigItemSize = CGSize(width: 500, height: 500)
    
    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }
    
    private var bigImageSize: CGSize {
        return CGSize(width: Self.bigItemSize.width, height: Self.bigItemSize.height)
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
    ]
    
    private static let barHeightFactor = 0.15
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
                            ForEach(model.photoCollection.photoAssets) { asset in
                                Button {
                                    if let index = selectedImages.firstIndex(where: { $0.identifier == asset.identifier }) {
                                        selectedImages.remove(at: index)
                                    } else {
                                        selectedImages.append(asset)
                                    }
                                } label: {
                                    photoItemView(asset: asset)
                                        .buttonStyle(.borderless)
                                        .accessibilityLabel(asset.accessibilityLabel)
                                }
                            }
                        }
                        .padding([.vertical], Self.itemSpacing)
                    }
                    .padding(.top, Self.itemSpacing)
                }
            }
            .task {
                await model.loadPhotos()
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    NavigationLink {
                        CameraView(model: model) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if let asset = model.photoCollection.photoAssets.first {
                                    selectedImages.append(asset)
                                }
                            }
                        }
                    } label: {
                        VStack {
                            Image(systemName: "camera.fill")
                        }
                        .frame(width: 90, height: 45)
                        .background(Color.blueLight)
                        .cornerRadius(45 / 2)
                        .shadow(radius: 0.4, y: 1)
                        .padding(Self.itemSpacing)
                    }
                    Spacer()
                    FloatingButton(title: "ADD", enabled: !selectedImages.isEmpty) {
                        Task {
                            await cache.stopCaching()
                            var imgs: [UIImage] = []
                            for asset in self.selectedImages {
                                await model.photoCollection.cache.requestImage(for: asset, targetSize: bigImageSize, completion: { result in
                                    guard let img = result?.image else { return }
                                    imgs.append(img)
                                })
                            }
                            
                            await MainActor.run { [imgs] in
                                self.onSelectImage?(imgs)
                                pop()
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(asset: asset, cache: model.photoCollection.cache, imageSize: bigImageSize)
            .frame(width: Self.itemSize.width, height: Self.itemSize.height)
            .clipped()
            .cornerRadius(Self.itemCornerRadius)
            .overlay(alignment: .topTrailing) {
                if selectedImages.first(where: { $0.identifier == asset.identifier }) != nil {
                    Image("ic_selected")
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 1)
                        .font(.callout)
                        .offset(x: -8, y: 8)
                }
            }
            .onAppear {
                Task {
                    await model.photoCollection.cache.startCaching(for: [asset], targetSize: bigImageSize)
                }
            }
            .onDisappear {
                Task {
                    await model.photoCollection.cache.stopCaching(for: [asset], targetSize: bigImageSize)
                }
            }
    }
}

