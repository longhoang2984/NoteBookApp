//
//  NewNoteViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 22/01/2023.
//

import SwiftUI
import RichTextKit

final class NewNoteViewModel: NSObject, ObservableObject {
    @Published var noteName: String = ""
    @Published var nameEditing = false
    @Published var categoryName: String = ""
    
    @Published var noteContent = NSAttributedString.empty
    @Published var content: String = ""
    
    @Published var shouldShowTodoList = false
    @Published var todoItems: [TodoItem] = []
    @Published var focusState: TodoItem?
    @Published var textEditorHeight : CGFloat = 200
    
    @Published var showImageLibrary: Bool = false
    @Published var selectedImages: [UIImage] = []
    
    @Published var showRecordView: Bool = false
    @Published var recordURL: URL?
    
    @Published var showLocation: Bool = false
    @Published var location: Place?
    
    @Published var showOptions: Bool = false
    
    @Published var showCategory: Bool = false
    @Published var selectedCategory: NoteCategory?
    @Published var categories: [NoteCategory] = []
    
    @Published var addingNewCategory: Bool = false
    @Published var newCategory = NoteCategory(id: UUID().uuidString, name: "", isNew: true)
    
    @Published var renderedImage: UIImage?
    @Published var showSendAcitivity: Bool = false
    
    @Published var pdf: Data?
    @Published var showSharePDF: Bool = false
    
    @Published var hideRemoveIcon: Bool = false
    
    @Published var showBlockDialog = false
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @MainActor
    func selectMenu(_ menu: NewNoteMenuType) {
//        focusState = nil
//
//        switch menu {
//        case .send:
//            share(content)
//        default:
//            break
//        }
    }
    
    func onSubmitInTodoItem(currentItem: TodoItem) {
        
        if let index = todoItems.firstIndex(where: { $0.id == currentItem.id }) {
            if todoItems[index].name.isEmpty {
                focusState = nil
                if index < todoItems.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                        self?.todoItems.remove(at: index)
                    }
                }
            } else {
                let item = TodoItem(id: UUID(), name: "", isDone: false)
                if (index == todoItems.count - 1) {
                    todoItems.append(item)
                } else {
                    todoItems.insert(item, at: index + 1)
                }
                
                self.focusState = item
            }
        }
    }
    
    func addOrRemoteTodoItem(at index: Int? = nil) {
        if !shouldShowTodoList {
            addNewToDoItem(at: index)
            shouldShowTodoList = true
        } else if focusState == nil {
            addNewToDoItem(at: index)
        } else {
            focusState = nil
            if todoItems.count == 1 && todoItems.first?.name.isEmpty == true {
                todoItems = []
                shouldShowTodoList = false
            }
            
        }
    }
    
    private func addNewToDoItem(at index: Int? = nil) {
        let item = TodoItem(id: UUID(), name: "", isDone: false)
        if let index = index {
            todoItems.insert(item, at: index + 1)
        } else {
            todoItems.append(item)
        }
        
        self.focusState = item
    }
    
    func focus(_ state: TodoItem) {
        self.focusState = state
    }
    
    func unFocus() {
        self.focusState = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.todoItems.removeAll(where: { $0.name.isEmpty })
        }
    }
    
    func getCategories() {
        categories = [
            NoteCategory(id: UUID().uuidString, name: "Work", isNew: false),
            NoteCategory(id: UUID().uuidString, name: "Daily routine", isNew: false)
        ]
        
        selectedCategory = categories.first
    }
    
    func selectCategory(_ category: NoteCategory) {
        selectedCategory = category
        showCategory.toggle()
        newCategory.name = ""
        addingNewCategory = false
    }
    
    func onCategoryDialogDismiss() {
        if newCategory.name.count > 0 {
            selectedCategory = newCategory
        }
    }
    
    func share(_ content: UIImage, scale: CGFloat) {
        renderedImage = content
        showSendAcitivity = true
        hideRemoveIcon = true
    }
    
    func convertPdf(_ data: Data) {
        pdf = data
        showSharePDF = true
        hideRemoveIcon = true
    }
}

struct NoteCategory: Identifiable, Hashable {
    var id: String
    var name: String
    var isNew: Bool
}
