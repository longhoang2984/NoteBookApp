//
//  NotesView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/12/2022.
//

import SwiftUI

public struct ItemGroupViewModel {
    public let id: String = UUID().uuidString
    public var title: String
    public var items: [ItemViewModel]
}

struct NotesView: View {
    @FocusState private var isFocused: Bool
    @State var isSearching: Bool = false
    @State var keywordSearching = ""
    @State var showNewNote = false
    
    let columns = [GridItem](repeating: GridItem(.fixed((UIScreen.main.bounds.width - 30) / 2), spacing: 10), count: 2)
    
    @State var toDoItemGroups = [
        ItemGroupViewModel(
            title: "daily routine",
            items: [ItemViewModel(id: UUID().uuidString, title: "Shopping", images: ["ic_home_location_thumb", "ic_home_audio_thumb", "ic_home_audio_thumb"], deadline: "today", deadlineIcon: "icon_deadline", isLock: true),
                    ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline", isLock: false),
                    ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline", isLock: false),
                    ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline", isLock: false)
                   ]
        ),
        
        ItemGroupViewModel(
            title: "Work",
            items: [ItemViewModel(id: UUID().uuidString, title: "Shopping", images: ["ic_home_location_thumb", "ic_home_audio_thumb", "ic_home_audio_thumb"], deadline: "today", deadlineIcon: "icon_deadline", isLock: true),
                    ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline", isLock: false),
                    ItemViewModel(id: UUID().uuidString, title: "Study", images: ["ic_home_location_thumb"], deadline: "01:00", deadlineIcon: "icon_deadline", isLock: false)
                   ]),
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ForEach($toDoItemGroups, id: \.self.id) { $item in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                Text(item.title)
                                    .foregroundColor(.white)
                                    .font(.custom("Roboto", size: 14))
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 16)
                                    .lineLimit(1)
                            }
                            .frame(height: 40)
                            .background {
                                Color.blueSecondary
                            }
                            .cornerRadius(20, corners: [.topRight, .bottomRight])
                            
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach($item.items, id: \.self.id) { item in
                                CardItemView(item: item)
                                    .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: 166)
                            }
                        }
                        .padding(.leading, 10)
                    }
                }
                
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    headerView
                        .padding()
                }
                .background(Color.blueLight)
                .shadow(radius: 0)
            }
            
            Button {
                showNewNote.toggle()
            } label: {
                HStack {
                    Spacer()
                    Image("btn_add")
                        .padding(.trailing, 20)
                }
            }
        }
        .navigationTitle("")
        .background(Color("blue_light").ignoresSafeArea())
        .fullScreenCover(isPresented: $showNewNote) {
            NewNoteView()
        }
    }
    
    @ViewBuilder
    var headerView: some View {
        if !isSearching {
            ZStack(alignment: .center) {
                Text("Notes")
                    .foregroundColor(.blueOxford)
                    .font(.custom("Roboto", size: 20))
                    .fontWeight(.bold)
                    .opacity(isSearching ? 0 : 1)
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isSearching.toggle()
                            isFocused = true
                        }
                    } label: {
                        Image("ic_search")
                    }
                }
            }
            
        } else {
            HStack {
                Image("ic_search")
                TextField("Enter the note title", text: $keywordSearching) {
                    
                }
                .focused($isFocused)
                .accentColor(.blueOxford)
                .foregroundColor(.blueOxford)
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}

public extension Color {
    static var bluePrimary = Color("blue_primary")
    static var blueSecondary = Color("blue_secondary")
    static var blueOxford = Color("blue_oxford")
    static var blueLight = Color("blue_light")
    static var blueBubble = Color("blue_bubble")
    static var mischka = Color("mischka")
    static var appYellow = Color("yellow")
}
