//
//  NewNoteMenuView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 24/01/2023.
//

import SwiftUI
import Popovers

struct NewNoteMenuView: View {
    @Binding var show: Bool
    var onSend: () -> Void
    var onPdf: () -> Void
    var onBlock: () -> Void
    var onPrint: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        Templates.Menu(configuration: {
            $0.width = 180
            $0.backgroundColor = .mischka.opacity(0.5)
            $0.popoverAnchor = .topRight
            $0.cornerRadius = 15
            $0.showDivider = false
        }) {
            Templates.MenuItem {
                onSend()
            } label: { fade in
                HStack {
                    Image("icon_send")
                    
                    Text("Send")
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
            
            Templates.MenuItem {
                onPdf()
            } label: { fade in
                HStack {
                    Image("icon_pdf")
                    
                    Text("Turn to PDF")
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Templates.MenuItem {
                onBlock()
            } label: { fade in
                HStack {
                    Image("icon_block")
                    
                    Text("Block")
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Templates.MenuItem {
                onPrint()
            } label: { _ in
                HStack {
                    Image("icon_print")
                    
                    Text("Print")
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Templates.MenuItem {
                onDelete()
            } label: { _ in
                HStack {
                    Image("icon_delete_blue")
                    
                    Text("Delete")
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }

        } label: { fade in
            Image("icon_more")
                .opacity(fade ? 0.5 : 1)
        }

    }
}

struct NewNoteMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteMenuView(show: .constant(true), onSend: {}, onPdf: {}, onBlock: {}, onPrint: {}, onDelete: {})
    }
}
