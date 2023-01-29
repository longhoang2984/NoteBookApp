//
//  AddNewMenu.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 30/01/2023.
//

import SwiftUI
import Popovers

public enum AddNewMenuType: Int {
    case note = 0
    case reminder = 1
    case todoList = 2
}

extension AddNewMenuType: Identifiable {
    public var id: Int { self.rawValue }
    
    static var allCases: [AddNewMenuType] {
        [.note, .reminder, .todoList]
    }
    
    var image: Image {
        switch self {
        case .note:
            return Image(systemName: "note.text.badge.plus")
        case .reminder:
            return Image(systemName: "calendar.badge.clock")
        case .todoList:
            return Image(systemName: "checklist")
        }
    }
    
    var text: Text {
        var txt: Text
        switch self {
        case .note:
            txt = Text("Note")
        case .reminder:
            txt = Text("Reminder")
        case .todoList:
            txt = Text("Todo List")
        }
        
        return txt
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.slateGray)
    }
}

struct AddNewMenu: View {
    @Binding var show: Bool
    var onMenuSelected: (AddNewMenuType) -> Void
    
    var body: some View {
        Templates.Menu(configuration: {
            $0.originAnchor = .topRight
            $0.popoverAnchor = .bottomRight
            $0.cornerRadius = 15
            $0.showDivider = false
        }) {
            HStack {
                Spacer()
            }
            .frame(height: 10)
            ForEach(AddNewMenuType.allCases) { menu in
                Templates.MenuItem {
                    print("@*# \(menu.rawValue)")
                    onMenuSelected(menu)
                } label: { fade in
                    HStack {
                        menu.image
                        
                        menu.text
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
            HStack {
                Spacer()
            }
            .frame(height: 10)
        } label: { fade in
            ButtonAdd()
                .opacity(fade ? 0.5 : 1)
        }

    }
}

struct AddNewMenu_Previews: PreviewProvider {
    static var previews: some View {
        AddNewMenu(show: .constant(true), onMenuSelected: { _ in })
    }
}
