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
    @FocusState var focusItem: ToDoItem?
    
    var body: some View {
        VStack(alignment: .leading) {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        if items.count > 0 {
            ForEach($items) { $item in
                EditableToDoView(todo: $item, focus: _focusItem) { text in
                    if !text.isEmpty {
                        let item = ToDoItem()
                        items.append(item)
                        focusItem = item
                    } else {
                        items.removeLast()
                        focusItem = nil
                    }
                }
            }
        }
    }
}

struct EditableToDoView: View {
    
    @Binding var todo: ToDoItem
    @FocusState var focus: ToDoItem?
    @State var editing: Bool = false
    var onSubmit: (String) -> Void
    
    var body: some View {
        HStack {
            Button {
                todo.isComplete.toggle()
            } label: {
                Image(todo.isComplete ? "radio_btn_selected" : "radio_btn")
            }
            
            ZStack {
                HStack {
                    Text($todo.text.wrappedValue)
                        .strikethrough(todo.isComplete)
                    Spacer()
                }
                
                TextField("", text: $todo.text) { editingChanged in
                        editing = editingChanged
                    }
                    .onSubmit {
                        onSubmit(todo.text)
                    }
                    .foregroundColor(.clear)
                    .focused($focus, equals: todo)
            }
        }
    }
}

struct EditableToDoListView_Previews: PreviewProvider {
    
    struct Preview: View {
        let item = ToDoItem()
        var items: [ToDoItem] {
            [item]
        }
        
        @FocusState var focus: ToDoItem?
        
        var body: some View {
            EditableToDoListView(items: .constant(items), focusItem: _focus)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        focus = item
                    }
                }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
