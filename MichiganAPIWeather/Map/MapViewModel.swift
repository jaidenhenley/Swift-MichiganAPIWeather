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
    
    private var allBeaches: [Beach] = Beach.allBeaches
    var filteredBeaches: [Beach] = Beach.allBeaches
    
    var lastRegion: MKCoordinateRegion?
    var isZoomedOut: Bool = true
    
    func updateVisibleBeaches(in region: MKCoordinateRegion) {
        self.lastRegion = region
        
        self.isZoomedOut = region.span.latitudeDelta > 1.5
        
        let latDelta = region.span.latitudeDelta / 2.0
        let lonDelta = region.span.longitudeDelta / 2.0
        
        let latRange = (region.center.latitude - latDelta)...(region.center.latitude + latDelta)
        let lonRange = (region.center.longitude - lonDelta)...(region.center.longitude + lonDelta)
        
        self.filteredBeaches = allBeaches.filter { beach in
            latRange.contains(beach.coordinates.latitude) &&
            lonRange.contains(beach.coordinates.longitude)
        }
    }
    
    func makeClusters() -> [BeachCluster] {
        guard let region = lastRegion else { return [] }
        
        var buckets: [String: [Beach]] = [:]
        
        let gridSize = max(region.span.latitudeDelta / 6.0, 0.2)
        
        for beach in filteredBeaches {
            
            let latKey = Int(beach.coordinates.latitude / gridSize)
            let lonKey = Int(beach.coordinates.longitude / gridSize)
            
            let key = "\(latKey)-\(lonKey)"
            buckets[key, default: []].append(beach)
        }
        
        return buckets.values.map { beaches in
            
            let avgLat = beaches.map { $0.coordinates.latitude }.reduce(0, +) / Double(beaches.count)
            let avgLon = beaches.map { $0.coordinates.longitude }.reduce(0, +) / Double(beaches.count)
            
            return BeachCluster(
                coordinate: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon),
                beaches: beaches
            )
        }
    }
}

struct BeachCluster: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let beaches: [Beach]
}
