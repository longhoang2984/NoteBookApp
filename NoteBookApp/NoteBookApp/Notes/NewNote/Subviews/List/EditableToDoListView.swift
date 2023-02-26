//
//  EditableToDoListView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 01/01/2023.
//

import SwiftUI

struct EditableToDoView: View {
    
    var model: NewNoteViewModel
    @Binding var todo: TodoItem
    @Binding var focus: TodoItem?
    @State var textViewHeight: CGFloat = 30
    
    var isEditing: Bool {
        self.todo.id == self.focus?.id
    }
    
    var onSubmit: () -> Void
        
    var body: some View {
        
        HStack(alignment: .top) {
            Button {
                todo.isDone.toggle()
            } label: {
                Image(todo.isDone ? "radio_btn_selected" : "radio_btn")
            }
            
            TextView(text: $todo.name, heightToTransmit: $textViewHeight, isEditing: .constant(focus?.id == todo.id), onReturnAction:  {
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
        @State var item = TodoItem(id: UUID(), name: "", isDone: false)
        var items: [TodoItem] {
            [item]
        }
        
        @Binding var focus: TodoItem?
        
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
