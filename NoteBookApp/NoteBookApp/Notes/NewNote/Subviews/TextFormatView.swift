//
//  TextFormatView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 25/01/2023.
//

import SwiftUI
import RichTextKit

struct TextFormatView: View {
    @ObservedObject
    private var context: RichTextContext
    
    init(context: RichTextContext) {
        self._context = ObservedObject(wrappedValue: context)
    }
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    
                    editorButton(image: "bold", isActive: context.isBold) {
                        context.isBoldBinding.wrappedValue.toggle()
                    }
                    
                    editorButton(image: "italic", isActive: context.isItalic) {
                        context.isItalic.toggle()
                    }
                    
                    editorButton(image: "underline", isActive: context.isUnderlined) {
                        context.isUnderlined.toggle()
                    }
                    
                    ColorPicker("", selection: context.foregroundColorBinding)
                    
                    editorButton(image: "cross_out", isActive: context.isStrikethrough) {
                        context.isStrikethrough.toggle()
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                
            }
        }
        .frame(height: 48)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1.0)
        .padding(.horizontal)
        
    }
    
    func editorButton(image: String, isActive: Bool, onTap: @escaping () -> Void) -> some View {
        HStack {
            Button {
                onTap()
            } label: {
                Image(image)
            }
            .frame(width: 30, height: 30)
            .background(isActive ? Color.blueLight : .clear)
            
            Rectangle()
                .fill(Color.mischka)
                .frame(width: 2, height: 30)
        }
    }
}

struct TextFormatView_Previews: PreviewProvider {
    static var previews: some View {
        TextFormatView(context: RichTextContext())
    }
}
