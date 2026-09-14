//
//  LocationManager.swift
//  Location Client iOS
//
//  Created by row64 on 9/14/26.
//

import CoreLocation
internal import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
        // Set the delegate to receive location updates
        locationManager.delegate = self
        
        // Desired accuracy level
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request permission to use location services
        // requestWhenInUseAuthorization is for foreground location only
        locationManager.requestWhenInUseAuthorization()                     // Request only when needed, not when initialized? ***********
        
        // Start updating location
//        locationManager.startUpdatingLocation()
    }
    
    
    // Start receiving location updates
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    // Stop receiving location updates
    func stopLocationUpdates() { locationManager.stopUpdatingLocation() }
    
    
    
    // ----------------------------------------------------------------------
    // Location delegates
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            // Access the current location
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            
//            // For testing
//            print("Latitude: \(latitude), Longitude: \(longitude)")
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                print("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    
    
    // ----------------------------------------------------------------------
    
}
