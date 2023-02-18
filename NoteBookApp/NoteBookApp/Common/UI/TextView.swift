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
    var placeHolder: String = ""
    var length: Int = 100
    
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
        textView.text = text
        if text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor(named: "mischka")
        }
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
        DispatchQueue.main.async {
            if isEditing {
                context.coordinator.textView?.becomeFirstResponder()
            } else {
                context.coordinator.textView?.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public class Coordinator : NSObject, UITextViewDelegate {
        var parent: TextView
        var textView : UITextView?
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            textView.sizeToFit()
            parent.heightToTransmit = textView.contentSize.height
        }
        
        public func textViewDidBeginEditing(_ textView: UITextView) {
            parent.onFocusAction?(true)
            if textView.text == parent.placeHolder {
                textView.text = ""
                textView.textColor = UIColor(named: "blue_oxford")
            }
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            parent.onFocusAction?(false)
            if textView.text.isEmpty {
                textView.text = parent.placeHolder
                textView.textColor = UIColor(named: "mischka")
            }
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" && parent.onReturnAction != nil {
                parent.onReturnAction?()
                return false
            }
            
            if textView.text == "" && text == "" {
                parent.onReturnAction?()
                return false
            }
            
            return (textView.text + text).count <= self.parent.length
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
            VStack(spacing: 0) {
                TextView(text: $text,
                         heightToTransmit: $heightToTransmit,
                         isEditing: .constant(true))
                    .frame(height: heightToTransmit)
                
                Rectangle()
                    .fill(isEditing ? Color.bluePrimary : Color.mischka)
                    .frame(height: 2)
                
                Text("\(heightToTransmit)")
            }
            .frame(maxHeight: .infinity)
            .background(.red)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
