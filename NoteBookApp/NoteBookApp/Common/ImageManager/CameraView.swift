//
//  CameraView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 18/01/2023.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject
    var model: CameraViewModel
    var onPhotoTaken: (() -> Void)?
    
    init(model: CameraViewModel, onPhotoTaken: (() -> Void)? = nil) {
        self._model = ObservedObject(wrappedValue: model)
        self.onPhotoTaken = onPhotoTaken
    }
    
    private static let barHeightFactor = 0.15
    @Environment(\.dismiss) var pop
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Color.black
                    HStack {
                        ViewfinderView(image:  $model.viewFinderImage )
                    }
                }
            }
            .task {
                await model.camera.start()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
        .onAppear {
            model.onPhotoTaken = {
                Task { @MainActor in
                    await model.loadPhotos()
                    onPhotoTaken?()
                    pop()
                }
            }
        }
        .onDisappear {
            model.onPhotoTaken = nil
        }
        .safeAreaInset(edge: .bottom) {
            buttonsView()
             .padding(.bottom, 20)
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            Button {
                pop()
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
    }
    
}

