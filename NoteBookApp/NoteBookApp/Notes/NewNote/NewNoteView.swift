//
//  NewNoteView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 30/12/2022.
//

import SwiftUI
import RichTextKit
import Popovers
import MobileCoreServices

struct NewNoteView: View {
    
    @Environment(\.dismiss) var pop
    
    @StateObject
    var context = RichTextContext()
    @StateObject var model = NewNoteViewModel()
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                content()
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
        .sheet(isPresented: $model.showLocation) {
            LocationView { place in
                model.location = place
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .scrollDismissesKeyboard(.interactively)
        .task {
            model.getCategories()
        }
        .sheet(isPresented: $model.showSendAcitivity, onDismiss: {
            model.hideRemoveIcon.toggle()
        }) { [renderedImage = model.renderedImage] in
            if let img = renderedImage {
                ShareSheet(activityItems: [img])
            }
        }
        .sheet(isPresented: $model.showSharePDF, onDismiss: {
            model.hideRemoveIcon.toggle()
        }) { [pdf = model.pdf] in
            if let pdf = pdf {
                ShareSheet(activityItems: [pdf])
            }
        }
    }
    
    func content(isViewing: Bool = false) -> some View {
        VStack {
            if isViewing {
                HStack {
                    HStack {
                        Spacer()
                    }
                    .frame(height: 30)
                }
            }
            
            InputField(editing: $model.nameEditing , text: $model.noteName, placeHolder: "Note name")
            
            Button {
                model.showCategory.toggle()
            } label: {
                ZStack {
                    InputField(editing: .constant(false), text: .constant(model.selectedCategory?.name ?? ""), placeHolder: "Category")
                        .disabled(true)
                    
                    HStack {
                        Spacer()
                        Image("icon_dropdown")
                    }
                    .padding()
                }
            }
            .padding(.bottom)
            .popover(present: $model.showCategory,
                     attributes: {
                $0.position = .absolute(
                    originAnchor: .bottomLeft,
                    popoverAnchor: .topLeft
                )
                $0.rubberBandingMode = .none
                $0.sourceFrameInset.bottom = 100
                $0.onDismiss = {
                    model.onCategoryDialogDismiss()
                }
            }) {
                NewNoteCategoryView(model: model)
                    .frame(maxHeight: 200)
            } background: {
                Color.mischka.opacity(0.5)
            }
            
            textFormat(isViewing: isViewing)
            
            VStack(alignment: .leading) {
                editor
                toDoList
                location(isViewing: isViewing)
                recordView(isViewing: isViewing)
                imgListView
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                Spacer()
            }
            .frame(height: 100)
        }
    }
    
    @ViewBuilder
    var toDoList: some View {
        if model.shouldShowTodoList {
            ForEach($model.todoItems, id: \.self.id) { $item in
                EditableToDoView(model: model, todo: $item, focus: $model.focusState, onSubmit: {
                    model.onSubmitInTodoItem(currentItem: item)
                })
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
                    
                    NewNoteMenuView(show: $model.showOptions) { menu in
                        switch menu {
                        case .send:
                            model.share(content(isViewing: true).asImage(), scale: displayScale)
                        case .pdf:
                            model.convertPdf(content(isViewing: true).toPDF(title: model.noteName))
                        default: break
                        }
                    }
                    
                }
                .padding(.horizontal)
            }
            .background(Color.white)
        }
        
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
                    model.addOrRemoteTodoItem()
                } label: {
                    Image("ic_list")
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    model.showLocation.toggle()
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
    func textFormat(isViewing: Bool = false) -> some View {
        if !isViewing {
            TextFormatView(context: context)
                .hide(isViewing)
        }
    }
    
    @ViewBuilder
    func recordView(isViewing: Bool = false) -> some View {
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
                .hide(isViewing)
            }
        }
    }
    
    @ViewBuilder
    func location(isViewing: Bool = false) -> some View {
        if let location = model.location {
            HStack(spacing: 15) {
                Image("ic_location")
                Text(location.place.name ?? "")
                    .font(.custom("Roboto-Regular", size: 16))
                Button {
                    model.location = nil
                } label: {
                    Image("icon_delete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(height: 34)
                .hide(isViewing)
            }
            .padding(12)
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

extension View {
    @ViewBuilder
    func hide(_ value: Bool = false) -> some View {
        if value {
            self
                .hidden()
        } else {
            self
        }
    }
    
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        // locate far out of screen
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }
    
    func toPDF(title: String) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let metadata = [kCGPDFContextCreator: "Torepa",
                         kCGPDFContextAuthor: "Torepa",
                          kCGPDFContextTitle: title,
                        kCGPDFContextSubject: title]
        
        format.documentInfo = metadata as Dictionary<String, Any>
        
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let contentSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: contentSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsPDFRenderer(bounds: controller.view.bounds, format: format)
        
        return renderer.pdfData { context in
            context.beginPage()
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return  windowScene?.windows.first
    }
    
}
