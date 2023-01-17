//
//  CardItemView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 26/12/2022.
//

import SwiftUI

public struct ItemViewModel: Identifiable, Hashable {
    public var id: String
    public var title: String
    public var images: [String]
    public var deadline: String
    public var deadlineIcon: String
    public var isLock: Bool
}

struct CardItemView: View {
    
    @Binding var item: ItemViewModel
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(alignment: .leading) {
                HStack {
                    Text(item.title)
                        .font(.custom("Roboto", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor( Color("blue_oxford"))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image("icon_lock")
                        .opacity(item.isLock ? 1 : 0)
                }
                ScrollView {
                    HStack(spacing: 4) {
                        ForEach(item.images.indices, id: \.self) { index in
                            Image(item.images[index])
                                .resizable()
                                .frame(width: (geo.size.width - 28) / 3,
                                       height: (geo.size.width - 28) / 3)
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Image(item.deadlineIcon)
                    Text(item.deadline)
                        .font(.custom("Roboto", size: 10))
                        .foregroundColor(Color("blue_secondary"))
                }
            }
            .padding(.all, 10)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: Color("mischka").opacity(0.4), radius: 4.0, y: 1)
        }
    }
}

struct CardItemView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
