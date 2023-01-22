//
//  MapView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 22/01/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var mapData: MapViewModel
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> some MKMapView {
        let view = mapData.mapView
        
        view.delegate = context.coordinator
        view.showsUserLocation = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.isKind(of: MKUserLocation.self) { return nil }
            
            let pinAnno = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
            pinAnno.tintColor = UIColor(named: "blue_primary") ?? .blue
            pinAnno.animatesWhenAdded = true
            pinAnno.canShowCallout = true
            
            return pinAnno
        }
    }
    
}
