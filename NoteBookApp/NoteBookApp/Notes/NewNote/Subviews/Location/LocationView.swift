//
//  LocationView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 22/01/2023.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mapData = MapViewModel()
    @FocusState var focus: Bool
    var onSelectLocation: (Place) -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                
                mapView
                
            }
        }
        .padding()
        .ignoresSafeArea(.keyboard)
        .task {
            mapData.requestLocation()
        }
        .alert(isPresented: $mapData.permissionDenied) {
            Alert(title: Text("Permission Denied"), message: Text("Please enabled permission in app settings"),
                  dismissButton: .default(Text("Go to Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        }
        .safeAreaInset(edge: .top) {
            VStack {
                HStack {
                    HStack {
                        Image("ic_search")
                        TextField("", text: $mapData.text)
                            .autocorrectionDisabled()
                            .focused($focus)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 48)
                .background(Color.mystic)
                .cornerRadius(24)
                .padding(.horizontal)
                .onChange(of: mapData.text, perform: { newValue in
                    let delay = 0.3
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if newValue == mapData.text {
                            mapData.searchLocation()
                        }
                    }
                })
                
                if !mapData.text.isEmpty && mapData.places.count > 0 {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(mapData.places) { place in
                                Text(place.place.name ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .onTapGesture {
                                        mapData.selectLocation(place: place)
                                        focus = false
                                    }
                                
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding(.top)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                FloatingButton(title: "ADD", enabled: mapData.selectedPlace != nil) {
                    guard let place = mapData.selectedPlace else { return }
                    onSelectLocation(place)
                    dismiss()
                }
            }
        }
    }
    
    @ViewBuilder
    var mapView: some View {
        if mapData.text.isEmpty {
            VStack {
                MapView()
                    .environmentObject(mapData)
                    .frame(height: UIScreen.main.bounds.width - 40)
                    .cornerRadius(20)
                    .padding(.bottom)
                
                Button {
                    mapData.focusMyLocation()
                } label: {
                    HStack(spacing: 15) {
                        Image("icon_location_blue")
                            .padding(.leading, 15)
                        
                        Text("Add my current location")
                            .font(.custom("Roboto-Medium", size: 16))
                            .foregroundColor(.slateGray)
                            .padding(.trailing, 15)
                        
                        Spacer()
                    }
                }
                .frame(height: 55)
                .background(.white)
                .cornerRadius(55.0 / 2)
                .shadow(color: .mischka, radius: 4.0)
                .padding(.horizontal, 2)
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(onSelectLocation: { _ in })
    }
}
