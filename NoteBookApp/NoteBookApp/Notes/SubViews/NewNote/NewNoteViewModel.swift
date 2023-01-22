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
    @Published var todoItems: [ToDoItem] = []
    @Published var focusState: ToDoItem?
    @Published var textEditorHeight : CGFloat = 200
    
    @Published var showImageLibrary: Bool = false
    @Published var selectedImages: [UIImage] = []
    
    @Published var showRecordView: Bool = false
    @Published var recordURL: URL?
    
    @Published var showLocation: Bool = false
    @Published var location: Place?
}
