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

struct EditableToDoView: View {
    
    var model: NewNoteViewModel
    @Binding var todo: ToDoItem
    @Binding var focus: ToDoItem?
    @State var textViewHeight: CGFloat = 30
    
    var isEditing: Bool {
        self.todo.id == self.focus?.id
    }
    
    var onSubmit: () -> Void
        
    var body: some View {
        
        HStack(alignment: .top) {
            Button {
                todo.isComplete.toggle()
            } label: {
                Image(todo.isComplete ? "radio_btn_selected" : "radio_btn")
            }
            
            TextView(text: $todo.text, heightToTransmit: $textViewHeight, isEditing: .constant(focus?.id == todo.id), onReturnAction:  {
                onSubmit()
            }, onFocusAction: { isFocus in
                if isFocus && focus?.id != todo.id {
                    model.focus(todo)
                } else if !isFocus && focus?.id == todo.id {
                    model.unFocus()
                }
            })
            .frame(height: textViewHeight)
            .padding(.top, -7)
            .background(Color.white)
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
                EditableToDoView(model: NewNoteViewModel(),
                                 todo: $item, focus: .constant(item),
                                 onSubmit: { })
            }
        }
    }
    
    static var previews: some View {
        
        Preview(focus: .constant(nil))
    }
}
