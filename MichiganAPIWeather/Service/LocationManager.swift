//
//  LocationManager.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/14/26.
//

import CoreLocation
import Foundation
import UIKit

@Observable
@MainActor
final class LocationManager: NSObject, CLLocationManagerDelegate {
    var userLocation: CLLocation?
    var authStatus: CLAuthorizationStatus
    var lastError: Error?
    
    private let manager = CLLocationManager()
    
    override init() {
        self.authStatus = CLLocationManager().authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.authStatus = manager.authorizationStatus
    }
    
    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }
    
    func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.last
        Task { @MainActor in
            self.userLocation = last
            self.lastError = nil
        }
        
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.lastError = error
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
            }
        }
    }
}

extension LocationManager {
    var isAuthorized: Bool {
        authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
    }
    
    var isDenied: Bool {
        authStatus == .denied || authStatus == .restricted
    }
}
