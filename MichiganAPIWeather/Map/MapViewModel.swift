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
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.0, longitude: -85.5),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )

    var beaches: [Beach] {
        Beach.allBeaches
    }
}
