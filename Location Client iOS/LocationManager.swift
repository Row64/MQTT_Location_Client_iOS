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
    var userLocation: CLLocationCoordinate2D?
    
    // Timer variables
    private var timer: Timer?
//    private var timerContinue: Bool = true
    
    // View
    private var view: ContentView?
    
    
    override init() {
        super.init()
        
        // Set the delegate to receive location updates
        locationManager.delegate = self
        
        // Desired accuracy level
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    /**
     This method routinely retrieves the user's current location using one of two strategies.
     
     This method can retrieve the user's location using the locationManager.startUpdatingLocation() method,
     which only sends updates when the device's location changes. If the location does not change, the method
     does not send an update.
     
     This method can alternatively send regular updates at a specified interval, regardless of whether the user
     moves or remains stationary. This is accomplished by wrapping the locationManager.requestLocaiton()
     method, which retrieves a one-time location update, in a Timer, which loops at the specified interval rate
     (in seconds).
     
     Once started, the Timer loop can be ended by calling the stopLocaitonUpdates() method, which simply
     toggles the value of timerContinue to false.
     
     Regardless of which strategy is used, the queried location (or error) is handled in the CLLocationManager's
     delegate methods.
     
     This method uses default values that configures the query to loop at an interval, every 5 seconds. These
     defaults can be overwritten when the method is called, if needed.
     */
    func startLocationUpdates(useInterval: Bool = true, interval: Double = 5.0) {
        
//        timerContinue = true
        
        // Request permissions to access location, if needed.
        locationManager.requestWhenInUseAuthorization()
        
        // FOR TESTING
        var timerLooped: Int = 0
        
        // Send location updates either using the default startUpdatingLocation() method,
        // or by looping at an interval.
        if (!useInterval) {
            // Only updates when the user's location changes
            // If location does not change, a new update is NOT sent.
            locationManager.startUpdatingLocation()
        }
        else {
            
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {timer in
                
                // Check if the loop can continue
                // Loop can be invalidated by calling LocationManager's stopLocationUpdates() method
//                if (self.timerContinue == false) { timer.invalidate() }
                
                // Get a one-time location value
                // Handle the value in the delegate
                self.locationManager.requestLocation()
                
                // FOR TESTING
                timerLooped += 1
                print("Timer completed loop \(timerLooped)")
                
            }
            
        }
        
    }
    
    
    // Stop receiving location updates
    func stopLocationUpdates() {
        
        timer?.invalidate()
        
//        timerContinue = false
        
        locationManager.stopUpdatingLocation()
        print("Location updates stopped.")
    }
    
    
    
    // ----------------------------------------------------------------------
    // Location delegates
    
    
    // For a successful location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                print("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                
                // Send location
                if (self.view != nil) {
                    self.view?.client.sendMessage(
                        topic: "location update",
                        msg: "\(location.coordinate.latitude), \(location.coordinate.longitude)"
                    )
                }
                else {
                    print("ERROR: Cannot send message. View is not initialized.")
                }
                
                
            }
        }
        
    }
    
    
    // For when the location manager is unable to retrieve a location value
    // https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/locationmanager(_:didfailwitherror:)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error when retrieving user location")
        print("Error: \(error.localizedDescription)")
    }
    
    
    // For when authorization status changes.
    // Informs the app whether it can access the user's location.
    // Gets called on initialization and when an authorization changes.
    // https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/locationmanagerdidchangeauthorization(_:)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Reached locationManagerDidChangeAuthorization delegate")
        print("\(manager.authorizationStatus)")
    }
    
    
    // ----------------------------------------------------------------------
    // Initializing functions
    
    func setView(v: ContentView) { view = v }
    
}
