//
//  NewNoteMenuView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 24/01/2023.
//

import SwiftUI
import Popovers

public enum NewNoteMenuType: Int {
    case send = 0
    case  pdf = 1
    case block = 2
    case print = 3
    case delete = 4
}

extension NewNoteMenuType: Identifiable {
    public var id: Int { self.rawValue }
    
    static var allCases: [NewNoteMenuType] {
        [.send, .pdf, .block, .print, .delete]
    }
    
    var image: Image {
        switch self {
        case .send:
            return Image("icon_send")
        case .pdf:
            return Image("icon_pdf")
        case .block:
            return Image("icon_block")
        case .print:
            return Image("icon_print")
        case .delete:
            return Image("icon_delete_blue")
        }
    }
    
    var text: Text {
        var txt: Text
        switch self {
        case .send:
            txt = Text("Send")
        case .pdf:
            txt = Text("Turn to PDF")
        case .block:
            txt = Text("Block")
        case .print:
            txt = Text("Print")
        case .delete:
            txt = Text("Delete")
        }
        
        return txt
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.slateGray)
    }
}

struct NewNoteMenuView: View {
    @Binding var show: Bool
    var onMenuSelected: (NewNoteMenuType) -> Void
    
    var body: some View {
        Templates.Menu(configuration: {
            $0.width = 180
            $0.popoverAnchor = .topRight
            $0.cornerRadius = 15
            $0.showDivider = false
        }) {
            EmptyView()
            ForEach(NewNoteMenuType.allCases) { menu in
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

        } label: { fade in
            Image("icon_more")
                .opacity(fade ? 0.5 : 1)
        }

    }
}

struct NewNoteMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteMenuView(show: .constant(true), onMenuSelected: { _ in })
    }
}
