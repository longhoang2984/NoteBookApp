//
//  TextView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 02/01/2023.
//

import SwiftUI

public struct TextView : UIViewRepresentable {
    @Binding public var text : String
    @Binding public var heightToTransmit: CGFloat
    @Binding public var isFirstResponder: Bool
    
    var onReturnAction: (() -> Void)? = nil
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let textView = UITextView(frame: .zero, textContainer: nil)
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "Roboto-Regular", size: 16)
        textView.contentInset = .zero
        textView.isScrollEnabled = false   // causes expanding height
        context.coordinator.textView = textView
        context.coordinator.onReturnAction = onReturnAction
        textView.text = text
        view.addSubview(textView)
        
        // Auto Layout
        textView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.heightBinding = $heightToTransmit
        context.coordinator.textBinding = $text
        switch isFirstResponder {
        case true:
            context.coordinator.textView?.becomeFirstResponder()
        case false:
            context.coordinator.textView?.resignFirstResponder()
        }
        DispatchQueue.main.async {
            context.coordinator.runSizing()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(isFirstResponder: $isFirstResponder)
    }
    
    public class Coordinator : NSObject, UITextViewDelegate {
        var textBinding : Binding<String>?
        var heightBinding : Binding<CGFloat>?
        var isFirstResponder: Binding<Bool>
        var textView : UITextView?
        var onReturnAction: (() -> Void)? = nil
        
        init(textBinding: Binding<String>? = nil,
             heightBinding: Binding<CGFloat>? = nil,
             isFirstResponder: Binding<Bool>,
             textView: UITextView? = nil,
             onReturnAction: (() -> Void)? = nil) {
            self.textBinding = textBinding
            self.heightBinding = heightBinding
            self.isFirstResponder = isFirstResponder
            self.textView = textView
            self.onReturnAction = onReturnAction
        }
        
        func runSizing() {
            guard let textView = textView else { return }
            textView.sizeToFit()
            if !textView.text.isEmpty {
                self.textBinding?.wrappedValue = textView.text
                self.heightBinding?.wrappedValue = textView.frame.size.height
            }
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            runSizing()
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            self.isFirstResponder.wrappedValue = true
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            self.isFirstResponder.wrappedValue = false
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" && onReturnAction != nil {
                onReturnAction?()
                return false
            }
            
            return true
        }
    }
}

struct TextView_Previews: PreviewProvider {
    
    struct Preview: View {
        @State var text: String = ""
        @State var heightToTransmit: CGFloat = 40
        @State public var isFirstResponder: Bool = true
        
        var body: some View {
            TextView(text: $text, heightToTransmit: $heightToTransmit, isFirstResponder: $isFirstResponder) {
                
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
