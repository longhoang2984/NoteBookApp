//
//  NewNoteView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 30/12/2022.
//

import SwiftUI
import RichTextKit

struct NewNoteView: View {
    
    @Environment(\.dismiss) var pop
    @State var noteName: String = ""
    @State var nameEditing = false
    @State var categoryName: String = ""
    
    @StateObject
    var context = RichTextContext()
    @State var noteContent = NSAttributedString.empty
    @State var content: String = ""
    
    @State private var shouldShowTodoList = false
    @State private var todoItems: [ToDoItem] = []
    @State var focusState: ToDoItem?
    @State private var textEditorHeight : CGFloat = 200
    
    @State var showImageLibrary: Bool = false
    @State var selectedImages: [UIImage] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                VStack {
                    InputField(editing: $nameEditing , text: $noteName, placeHolder: "Note name") {
                        
                    }
                    
                    ZStack {
                        InputField(editing: .constant(false), text: $categoryName, placeHolder: "Category")
                            .disabled(true)
                        
                        HStack {
                            Spacer()
                            Image("icon_dropdown")
                        }
                        .padding()
                    }
                    .padding(.bottom)
                    
                    TextFormatView(context: context)
                    VStack(alignment: .leading) {
                        editor
                        toDoList
                    }
                    .frame(maxHeight: .infinity)
                    
                    HStack {
                        Spacer()
                    }
                    .frame(height: 100)
                }
            }
        }.safeAreaInset(edge: .top) {
            header
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                footer
            }
        }
        .sheet(isPresented: $showImageLibrary) {
            ImagePicker(onSelectImage: { images in
                selectedImages = images
            })
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        
    }
    
    @ViewBuilder
    var toDoList: some View {
        if shouldShowTodoList {
            EditableToDoListView(items: $todoItems, focusItem: $focusState) { text in
                guard let focusItem = focusState, let index = todoItems.firstIndex(where: { $0.id == focusItem.id }) else { return }
                if !text.isEmpty {
                    let item = ToDoItem()
                    if (index == todoItems.count - 1) {
                        self.todoItems.append(item)
                    } else {
                        self.todoItems.insert(item, at: index + 1)
                    }
                    focusState = item
                } else {
                    self.todoItems.remove(at: index)
                    focusState = nil
                }
            }
        }
    }
    
    var editor: some View {
        RichTextEditor(text: $noteContent, context: context) {
            $0.textContentInset = CGSize(width: 10, height: 20)
        }
        .focusedValue(\.richTextContext, context)
        .frame(height: 250)
    }
    
    var header: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        pop()
                    } label: {
                        Image("icon_back")
                    }
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Text("Note")
                                .font(.custom("Roboto", size: 20))
                                .fontWeight(.bold)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("icon_more")
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.white)
        }
    }
    
    func addNewToDoItem() {
        let item = ToDoItem()
        todoItems.append(item)
        focusState = item
    }
    
    var footer: some View {
        VStack {
            HStack {
                HStack {
                    HStack {
                        RichTextActionButton(action: .undoLatestChange, context: context)
                            .foregroundColor(context.canUndoLatestChange ? .blueOxford : .mischka)
                        
                        RichTextActionButton(action: .redoLatestChange, context: context)
                            .foregroundColor(context.canRedoLatestChange ? .blueOxford : .mischka)
                        
                        Divider()
                        RichTextActionButtonStack(
                            context: context,
                            actions: [.dismissKeyboard],
                            spacing: 5
                        )
                        .foregroundColor(.blueOxford)
                    }
                    .padding()
                }
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 4.0)
                .padding(.leading, 16)
                .opacity(context.isEditingText ? 1.0 : 0)
                
                Spacer()
                
                FloatingButton(title: "Save") {
                    print(todoItems.count)
                }
            }
            HStack {
                Button {
                    if !shouldShowTodoList {
                        addNewToDoItem()
                        shouldShowTodoList = true
                    } else if focusState == nil {
                        addNewToDoItem()
                    } else {
                        focusState = nil
                        if todoItems.count == 1 && todoItems.first?.text.isEmpty == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                todoItems = []
                            }
                            shouldShowTodoList = false
                        }
                    }
                } label: {
                    Image("ic_list")
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Image("ic_location")
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Image("ic_audio")
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    showImageLibrary.toggle()
                } label: {
                    Image("ic_img")
                }
                .frame(maxWidth: .infinity, minHeight: 40)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

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
        .shadow(radius: 4.0)
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

extension RichTextStyle {
    var iconOne: Image {
        switch self {
        case .bold:
            return Image("bold")
        case .underlined:
            return Image("underline")
        case .strikethrough:
            return Image("cross_out")
        case .italic:
            return Image("italic")
        }
    }
}
