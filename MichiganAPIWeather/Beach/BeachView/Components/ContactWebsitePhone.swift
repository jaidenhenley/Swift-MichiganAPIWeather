//
//  ContactWebsitePhone.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/4/26.
//

import CoreLocation
import MapKit
import SwiftUI

struct ContactWebsitePhone: View {
    @EnvironmentObject private var viewModel: BeachViewModel

    var body: some View {
        HStack(spacing: 24) {
            ActionButton(icon: "globe", title: "Website") {
                // URL
            }
            ActionButton(icon: "map.fill", title: "Location") {
                guard let beach = viewModel.selectedBeach else { return }
                let coords = beach.beachCoordinates
                let placemark = MKPlacemark(coordinate: coords)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = viewModel.beachName
                mapItem.openInMaps()
            }
            ActionButton(icon: "phone.fill", title: "Call") {
                // Phone call
            }
        }
        .padding()
    }
}

#Preview {
    ContactWebsitePhone()
}
