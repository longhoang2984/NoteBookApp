//
//  View+Extensions.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 29/01/2023.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    @ViewBuilder
    func hide(_ value: Bool = false) -> some View {
        if value {
            self
                .hidden()
        } else {
            self
        }
    }
    
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        // locate far out of screen
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }
    
    func toPDF(title: String) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let metadata = [kCGPDFContextCreator: "Torepa",
                         kCGPDFContextAuthor: "Torepa",
                          kCGPDFContextTitle: title,
                        kCGPDFContextSubject: title]
        
        format.documentInfo = metadata as Dictionary<String, Any>
        
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let contentSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: contentSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsPDFRenderer(bounds: controller.view.bounds, format: format)
        
        return renderer.pdfData { context in
            context.beginPage()
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}
