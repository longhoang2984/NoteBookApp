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
    @Binding public var isEditing: Bool
    
    var onReturnAction: (() -> Void)? = nil
    var onFocusAction: ((Bool) -> Void)? = nil
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let textView = UITextView(frame: .zero, textContainer: nil)
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "Roboto-Regular", size: 16)
        textView.contentInset = .zero
        textView.isScrollEnabled = false   // causes expanding height
        textView.backgroundColor = .clear
        textView.textColor = UIColor(named: "blue_oxford")
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
        if isEditing {
            context.coordinator.textView?.becomeFirstResponder()
        } else {
            context.coordinator.textView?.resignFirstResponder()
        }
        DispatchQueue.main.async {
            context.coordinator.runSizing()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(onReturnAction:
                            onReturnAction,
                           onFocusAction: onFocusAction)
    }
    
    public class Coordinator : NSObject, UITextViewDelegate {
        var textBinding : Binding<String>?
        var heightBinding : Binding<CGFloat>?
        var textView : UITextView?
        var onReturnAction: (() -> Void)? = nil
        var onFocusAction: ((Bool) -> Void)? = nil
        var isEditing: Bool = false
        
        init(textBinding: Binding<String>? = nil,
             heightBinding: Binding<CGFloat>? = nil,
             textView: UITextView? = nil,
             onReturnAction: (() -> Void)? = nil,
             onFocusAction: ((Bool) -> Void)? = nil,
             isEditing: Bool = false) {
            self.textBinding = textBinding
            self.heightBinding = heightBinding
            self.textView = textView
            self.onReturnAction = onReturnAction
            self.isEditing = isEditing
            self.onFocusAction = onFocusAction
        }
        
        func runSizing() {
            guard let textView = textView else { return }
            textView.sizeToFit()
            self.heightBinding?.wrappedValue = textView.frame.size.height
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            textBinding?.wrappedValue = textView.text
            runSizing()
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            self.onFocusAction?(true)
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            self.onFocusAction?(false)
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" && onReturnAction != nil {
                onReturnAction?()
                return false
            }
            
            if text == "" && range.length == 1 {
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
        @State public var isEditing: Bool = false
        
        var body: some View {
            TextView(text: $text, heightToTransmit: $heightToTransmit, isEditing: $isEditing) {
                
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
