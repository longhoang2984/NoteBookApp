//
//  ImageManager.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 05/01/2023.
//

import Foundation
import Photos
import UIKit
import SwiftUI

public struct Images {
    public var image: UIImage
    public var selected: Bool
    public var isCamera: Bool
    
    public init(image: UIImage, selected: Bool, isCamera: Bool) {
        self.image = image
        self.selected = selected
        self.isCamera = isCamera
    }
}

public class ImageManager: ObservableObject {
    @Published public var datas = [UIImage]()
    private var allPhotos : PHFetchResult<PHAsset>?
    @Published public var images: [Images] = [Images(image: UIImage(named: "")!, selected: false, isCamera: true)]
    @Published public var grid: [Int] = []
    
    func fetchingImages(imageSize: CGSize = .init(width: 100, height: 100)) async {
        guard await requestAuthorizeStatus() == .authorized else { return }
        
        let options = PHFetchOptions()

        if allPhotos == nil {
            allPhotos = PHAsset.fetchAssets(with: .image, options: options)
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.allPhotos?.enumerateObjects { asset, count, stop in
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                PHCachingImageManager.default().requestImage(for: asset,
                                                             targetSize: imageSize,
                                                             contentMode: .aspectFit,
                                                             options: options) { (img, _) in
                    guard let img = img else { return }
                    self?.datas.append(img)
                }
            }
            
            if self?.allPhotos?.count == self?.datas.count {
                self?.images = self?.datas.map({ img in
                    let image = Images(image: img, selected: false, isCamera: false)
                    return image
                }) ?? []
                
                self?.getGrid()
            }
        }
    }
    
    public func requestAuthorizeStatus() async -> PHAuthorizationStatus {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .notDetermined {
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return status
        } else {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        }
    }
    
    func getGrid() {
        for i in stride(from: 0, to: self.images.count, by: 3) {
            grid.append(i)
        }
    }
}
