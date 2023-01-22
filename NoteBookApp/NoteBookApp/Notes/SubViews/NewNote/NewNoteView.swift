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
    
    @StateObject
    var context = RichTextContext()
    @StateObject var model = NewNoteViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                VStack {
                    InputField(editing: $model.nameEditing , text: $model.noteName, placeHolder: "Note name") {
                        
                    }
                    
                    ZStack {
                        InputField(editing: .constant(false), text: $model.categoryName, placeHolder: "Category")
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
                        recordView
                        imgListView
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
        .sheet(isPresented: $model.showImageLibrary) {
            PhotoCollectionView(onSelectImage: { images in
                model.selectedImages += images
            })
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $model.showRecordView) {
            RecordingAudioView { url in
                model.recordURL = url
            }
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $model.showImageLibrary) {
            LocationView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    @ViewBuilder
    var toDoList: some View {
        if model.shouldShowTodoList {
            EditableToDoListView(items: $model.todoItems, focusItem: $model.focusState) { text, index in
                if !text.isEmpty {
                    let item = ToDoItem()
                    if (index == model.todoItems.count - 1) {
                        model.todoItems.append(item)
                    } else {
                        model.todoItems.insert(item, at: index + 1)
                    }
                    model.focusState = item
                } else {
                    model.focusState = nil
                    model.todoItems.remove(at: index)
                }
            }
        }
    }
    
    @ViewBuilder
    var imgListView: some View {
        if !model.selectedImages.isEmpty {
            PhotoListView(images: model.selectedImages) { index in
                _ = withAnimation {
                    model.selectedImages.remove(at: index)
                }
            }
            .padding(.top, 12)
        }
    }
    
    var editor: some View {
        RichTextEditor(text: $model.noteContent, context: context) {
            $0.textContentInset = CGSize(width: 10, height: 20)
            $0.setCurrentForegroundColor(to: UIColor(named: "blue_oxford") ?? .black)
        }
        .onAppear {
            context.foregroundColorBinding.wrappedValue = .blueOxford
        }
        .foregroundColor(.blueOxford)
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
                                .foregroundColor(.blueOxford)
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
        model.todoItems.append(item)
        model.focusState = item
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
                    print(model.todoItems.count)
                }
            }
            HStack {
                Button {
                    if !model.shouldShowTodoList {
                        addNewToDoItem()
                        model.shouldShowTodoList = true
                    } else if model.focusState == nil {
                        addNewToDoItem()
                    } else {
                        model.focusState = nil
                        if model.todoItems.count == 1 && model.todoItems.first?.text.isEmpty == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                model.todoItems = []
                            }
                            model.shouldShowTodoList = false
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
                    model.showRecordView.toggle()
                } label: {
                    Image("ic_audio")
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    model.showImageLibrary.toggle()
                } label: {
                    Image("ic_img")
                }
                .frame(maxWidth: .infinity, minHeight: 40)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
    
    @ViewBuilder
    var recordView: some View {
        if let url = model.recordURL {
            HStack(spacing: 8) {
                RecordedAudioPlayerView(url: url)
                    .padding(.leading, 12)
                
                Button {
                    model.recordURL = nil
                } label: {
                    Image("icon_delete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(height: 34)
            }
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
