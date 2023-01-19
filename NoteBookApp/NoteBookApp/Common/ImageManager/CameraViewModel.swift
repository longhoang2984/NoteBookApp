//
//  CameraViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 18/01/2023.
//

import AVFoundation
import SwiftUI
import os.log

fileprivate let logger = Logger(subsystem: "com.hoangcuulong.notebook", category: "CameraViewModel")

public final class CameraViewModel: ObservableObject {
    
    let camera = Camera()
    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    
    @Published public var viewFinderImage: Image?
    @Published public var thumbnailImage: Image?
    
    var isPhotoLoaded = false
    var onPhotoTaken: (() -> Void)?
    let saveSquareImage: Bool
    
    init(saveSquareImage: Bool = false) {
        self.saveSquareImage = saveSquareImage
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
        
    }
    
    /// Handle Camera previews
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }
        
        for await image in imageStream {
            Task { @MainActor in
                viewFinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
            }
            savePhoto(imageData: photoData.imageData)
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        
        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metaDataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metaDataOrientation)
        else { return nil }
        
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        let defaultData = PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
        guard let img = UIImage(data: imageData),
              img.cgImage != nil,
              saveSquareImage
        else { return defaultData }
        
        guard let data = cropToBounds(image: img, width: img.size.width, height: img.size.width).jpegData(compressionQuality: 1)
        else { return defaultData }
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: data, imageSize: imageSize)
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.aspectRatio()
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    func savePhoto(imageData: Data, albumName: String = "Torepa") {
        
        Task {
            do {
                try await photoCollection.addImage(imageData, albumName: albumName)
                logger.debug("Add Image data to photo collection")
                onPhotoTaken?()
            } catch let error {
                logger.error("Failed to add image to photo collection: \(error.localizedDescription)")
            }
        }
    }
    
    func loadPhotos() async {
        guard !isPhotoLoaded else { return }
        
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else {
            logger.error("Photo library access was not authorized.")
            return
        }
        
        Task {
            do {
                try await self.photoCollection.load()
                await self.loadThumbnail()
            } catch let error {
                logger.error("Failed to load photo collection: \(error.localizedDescription)")
            }
            
            self.isPhotoLoaded = true
        }
    }
    
    func loadThumbnail() async {
        guard let asset = photoCollection.photoAssets.first  else { return }
        await photoCollection.cache.requestImage(for: asset, targetSize: CGSize(width: 256, height: 256))  { result in
            if let result = result {
                Task { @MainActor in
                    guard let img = result.image else { return }
                    self.thumbnailImage = Image(uiImage: img)
                }
            }
        }
    }
}

fileprivate struct PhotoData {
    
    var thumbnailImage: Image
    
    var thumbnailSize: (width: Int, height: Int)
    
    var imageData: Data
    
    var imageSize: (width: Int, height: Int)
    
}

extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        
        let imageRef = cgImage.aspectRatio()
        
        return Image(decorative: imageRef, scale: 1.0, orientation: .up)
    }
}

extension CGImage {
    func aspectRatio() -> CGImage {
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if cgwidth > cgheight {
            posX = ((cgwidth - cgheight) / 2)
            posY = 0
            cgwidth = cgheight
        } else {
            posX = 0
            posY = ((cgheight - cgwidth) / 2)
            cgheight = cgwidth
        }
        
        let rect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        guard let imageRef = cropping(to: rect) else { return self }
        
        return imageRef
    }
}

extension Image.Orientation {
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        }
    }
}
