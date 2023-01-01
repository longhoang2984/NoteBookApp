//
//  TextStyleButtonStack.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 31/12/2022.
//

import SwiftUI
import RichTextKit

struct TextStyleButtonStack: View {
    
    @ObservedObject
    private var context: RichTextContext
    private let spacing: Double
    private let styles: [AppTextStyle]
    private let buttonStyle: TextStyleButtonToggle.Style
    
    public init(
        context: RichTextContext,
        styles: [AppTextStyle] = .all,
        spacing: Double = 5,
        buttonStyle: TextStyleButtonToggle.Style  = .standard
        
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.styles = styles
        self.spacing = spacing
        self.buttonStyle = buttonStyle
    }
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                ForEach(styles) {
                    TextStyleButtonToggle(style: $0, context: context)
                }
            }
        }
        .frame(height: 48)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4.0)
        .padding(.horizontal)
    }
    
    private func editorButton(image: String, onTap: @escaping () -> Void) -> some View {
        HStack {
            Button {
                onTap()
            } label: {
                Image(image)
            }
            .frame(width: 30, height: 30)
            
            Rectangle()
                .fill(Color.mischka)
                .frame(width: 2, height: 30)
        }
    }
}

public struct TextStyleButtonToggle: View {
    
    @ObservedObject
    private var context: RichTextContext
    private let style: AppTextStyle
    private let buttonStyle: Style
    private let fillVertically: Bool
    private let customImage: Image?
    
    public init(
        style: AppTextStyle,
        buttonStyle: Style = .standard,
        context: RichTextContext,
        fillVertically: Bool = false,
        customImage: Image? = nil
    ) {
        self.style = style
        self.buttonStyle = buttonStyle
        self._context = ObservedObject(wrappedValue: context)
        self.fillVertically = fillVertically
        self.customImage = customImage
    }
    
    public var body: some View {
        HStack {
            Text("")
        }
    }
}

public extension TextStyleButtonToggle {
    
    struct Style {
        public init(
            inactiveColor: Color? = nil,
            activeColor: Color = .blueOxford
        ) {
            self.inactiveColor = inactiveColor
            self.activeColor = activeColor
        }
        
        public var inactiveColor: Color?
        public var activeColor: Color
    }
    
}

public extension TextStyleButtonToggle.Style {
    static var standard = TextStyleButtonToggle.Style()
}

struct TextStyleButtonStack_Previews: PreviewProvider {
    
    struct Preview: View {
        @StateObject
        private var context = RichTextContext()
        
        var body: some View {
            TextStyleButtonStack(context: context)
                .padding()
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
