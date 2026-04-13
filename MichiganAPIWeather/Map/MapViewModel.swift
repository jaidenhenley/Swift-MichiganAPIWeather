//
//  MapViewModel.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import MapKit
import SwiftUI

@Observable
class MapViewModel {
    // This is your master list
    private var allBeaches: [Beach] = Beach.allBeaches
    
    // This is what the View actually displays
    var filteredBeaches: [Beach] = Beach.allBeaches

    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.0, longitude: -85.5),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )

    func updateVisibleBeaches(in region: MKCoordinateRegion) {
        // Calculate the boundaries of the current map view
        let latDelta = region.span.latitudeDelta / 2.0
        let lonDelta = region.span.longitudeDelta / 2.0
        
        let latRange = (region.center.latitude - latDelta)...(region.center.latitude + latDelta)
        let lonRange = (region.center.longitude - lonDelta)...(region.center.longitude + lonDelta)
        
        // Update the list shown in the ScrollView
        self.filteredBeaches = allBeaches.filter { beach in
            latRange.contains(beach.coordinates.latitude) &&
            lonRange.contains(beach.coordinates.longitude)
        }
    }
}
