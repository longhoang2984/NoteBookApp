//
//  EditableToDoListView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

import SwiftUI

public struct ToDoItem: Identifiable, Hashable {
    public var id: String
    public var text: String
    public var isComplete: Bool
    
    public init(id: String  = UUID().uuidString,
                text: String = "",
                isComplete: Bool = false) {
        self.id = id
        self.text = text
        self.isComplete = isComplete
    }
}

struct EditableToDoListView: View {
    
    @Binding var items: [ToDoItem]
    @Binding var focusItem: ToDoItem?
    var onSubmit: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        if items.count > 0 {
            ForEach($items, id: \.self.id) { $item in
                EditableToDoView(todo: $item, focus: _focusItem, onSubmit: onSubmit)
            }
        }
    }
}

struct EditableToDoView: View {
    
    @Binding var todo: ToDoItem
    @Binding var focus: ToDoItem?
    @State var textViewHeight: CGFloat = 40
    
    var isEditing: Bool {
        self.todo.id == self.focus?.id
    }
    
    var onSubmit: (String) -> Void
        
    var body: some View {
        
        HStack(alignment: .top) {
            Button {
                todo.isComplete.toggle()
            } label: {
                Image(todo.isComplete ? "radio_btn_selected" : "radio_btn")
            }
            
            let firstResponding = Binding(get: { isEditing }) { isEditing in
                if !isEditing {
                    focus = nil
                }
            }
            
            TextView(text: $todo.text, heightToTransmit: $textViewHeight, isEditing: firstResponding) {
                onSubmit(todo.text)
            } onFocusAction: { focused in
                if !focused {
                    focus = nil
                } else {
                    focus = todo
                }
            }
            .frame(height: textViewHeight)
            .background(Color.white)
            .padding(.top, -7)
        }
        .padding(.horizontal)
    }
}

struct EditableToDoListView_Previews: PreviewProvider {
    
    struct Preview: View {
        @State var item = ToDoItem()
        var items: [ToDoItem] {
            [item]
        }
        
        @Binding var focus: ToDoItem?
        
        var body: some View {
            VStack {
                EditableToDoView(todo: $item, focus: .constant(nil), onSubmit: { _ in })
                
                EditableToDoListView(items: .constant(items), focusItem: _focus, onSubmit: { _ in })
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            focus = item
                        }
                    }
            }
        }
    }
    
    static var previews: some View {
        
        Preview(focus: .constant(nil))
    }
}
