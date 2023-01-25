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
        locationManager.startUpdatingLocation()
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
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        self.mapView.setRegion(self.region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func focusMyLocation() {
        guard let _ = region else { return }
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] places, err in
            guard let self = self, let places = places, let place = places.first else { return }
            self.selectedPlace = Place(place: place)
            self.addAnnotation()
        }
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
        
        selectedPlace = place
        addAnnotation()
    }
    
    private func addAnnotation() {
        guard let place = selectedPlace, let coordinate = place.place.location?.coordinate else { return }
        let pointAnno = MKPointAnnotation()
        pointAnno.coordinate = coordinate
        pointAnno.title = place.place.name ?? "No name"
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnno)
        
        let coorRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coorRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
}
