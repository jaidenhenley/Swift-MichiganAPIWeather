//
//  Beach+Distance.swift
//  MichiganAPIWeather
//

import CoreLocation

extension Beach {
    func distanceInMiles(from location: CLLocation) -> Double {
        let beachLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        return location.distance(from: beachLocation) / 1609.344
    }
}

extension Array where Element == Beach {
    func sortedByDistance(from location: CLLocation, limit: Int? = nil) -> [Beach] {
        let sorted = self
            .map { ($0, $0.distanceInMiles(from: location)) }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
        
        if let limit { return Array(sorted.prefix(limit)) }
        return sorted
    }
}
