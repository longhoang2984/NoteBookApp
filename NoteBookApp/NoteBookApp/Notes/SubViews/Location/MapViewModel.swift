//
//  MapViewModel.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 22/01/2023.
//

import Foundation
import MapKit
import CoreLocation

struct Place: Identifiable {
    let id: String = UUID().uuidString
    let place: CLPlacemark
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    
    @Published var region: MKCoordinateRegion!
    
    @Published var permissionDenied: Bool = false
    
    @Published var text: String = ""
    
    @Published var searching: Bool = false
    @Published var places: [Place] = []
    @Published var selectedPlace: Place?
    @Published var focus: Bool = false
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .authorizedAlways:
            manager.requestLocation()
        case .restricted:
            print("retricted")
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            self.mapView.setRegion(self.region, animated: true)
            
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func focusMyLocation() {
        guard let _ = region else { return }
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        
        places.removeAll()
        MKLocalSearch(request: request).start { [weak self] (response, _) in
            guard let self = self,
                  let result = response else { return }
            self.places = result.mapItems.compactMap { Place(place: $0.placemark) }
            if result.mapItems.count > 0 {
                self.searching.toggle()
            }
        }
    }
    
    func selectLocation(place: Place) {
        text = ""
        focus = false
        
        guard let coordinate = place.place.location?.coordinate else { return }
        let pointAnno = MKPointAnnotation()
        pointAnno.coordinate = coordinate
        pointAnno.title = place.place.name ?? "No name"
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnno)
        
        selectedPlace = place
        
        let coorRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coorRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
}
