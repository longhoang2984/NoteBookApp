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
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
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
                            .padding(.top, 20)
                            
                            Spacer()
                        }
                        
                        HStack {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                ForEach($item.items, id: \.self.id) { item in
                                    CardItemView(item: item)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    ZStack(alignment: .center) {
                        Text("Notes")
                            .foregroundColor(.blueOxford)
                            .font(.custom("Roboto", size: 20))
                            .fontWeight(.bold)
                            .opacity(isSearching ? 0 : 1)
                        
                        headerView
                            .padding(.horizontal, 16)
                    }
                }
            }
            
            Button {
                var group = toDoItemGroups[1]
                var items = group.items
                items.append(ItemViewModel(id: UUID().uuidString, title: "Shopping", images: ["ic_home_location_thumb", "ic_home_audio_thumb", "ic_home_audio_thumb"], deadline: "today", deadlineIcon: "icon_deadline", isLock: true))
                group.items = items
                toDoItemGroups[1] = group
            } label: {
                HStack {
                    Spacer()
                    Image("btn_add")
                        .padding(.trailing, 20)
                }
            }
        }
        .background(Color("blue_light").ignoresSafeArea())
    }
    
    @ViewBuilder
    var headerView: some View {
        if !isSearching {
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

extension Color {
    static var bluePrimary = Color("blue_primary")
    static var blueSecondary = Color("blue_secondary")
    static var blueOxford = Color("blue_oxford")
    static var blueLight = Color("blue_light")
    static var mischka = Color("mischka")
}
