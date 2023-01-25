//
//  NewNoteCategoryView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 25/01/2023.
//

import SwiftUI
import Popovers

struct NewNoteCategoryView: View {
    @StateObject var model: NewNoteViewModel
    @FocusState var newCategoryFocus: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(model.categories, id: \.self.id) { category in
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                            polygon(category.id == model.selectedCategory?.id)
                            
                            HStack {
                                Text(category.name)
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .fontWeight(category.id == model.selectedCategory?.id ? .bold : .none)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                model.selectCategory(category)
                            }
                        }
                        .id(category)
                    }
                }
                .onAppear {
                    if let category = model.selectedCategory, let index = model.categories.firstIndex(where: { $0.id == category.id }) {
                        proxy.scrollTo(category, anchor: index >= model.categories.count - 3 ? .bottom : .center)
                    }
                }
                
                addCategory
            }
            .padding(.vertical, 10)
        }
        .popoverShadow(shadow: .system)
        .frame(width: 260)
        .background(.white)
        .scaleEffect(!model.showCategory ? 2 : 1)
        .opacity(!model.showCategory ? 0 : 1)
        .cornerRadius(16)
        .shadow(radius: 2.0)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {

            }
        }
    }
    
    @ViewBuilder
    private func polygon(_ isSelected: Bool) -> some View {
        if isSelected {
            Image("ic_polygon")
        }
    }
    
    @ViewBuilder
    private var addCategory: some View {
        if model.addingNewCategory {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                Image("ic_polygon")
                
                TextField("New Category", text: $model.newCategory.name)
                    .padding(.horizontal, 16)
                    .focused($newCategoryFocus)
                    .onAppear {
                        newCategoryFocus = true
                    }
            }
            .padding(.bottom, 12)
        } else {
            Button {
                model.selectedCategory = model.newCategory
                model.addingNewCategory.toggle()
            } label: {
                HStack {
                    Text("+")
                        .foregroundColor(.blueSecondary)
                    
                    Text("Add new")
                    
                    Spacer()
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
    }
}

struct NewNoteCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
    }
}
