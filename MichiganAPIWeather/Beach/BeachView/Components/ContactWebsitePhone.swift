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
    @Environment(BeachViewModel.self) var viewModel
    
    var body: some View {
        HStack(spacing: 24) {
            ActionButton(icon: "globe", title: "Website") {
                if let url = viewModel.selectedBeach?.websiteURL {
                    UIApplication.shared.open(url)
                }
            }
            .accessibilityLabel("Visit website")
            .accessibilityHint("Opens the beach website in Safari")
            Spacer()
            ActionButton(icon: "map.fill", title: "Location") {
                guard let beach = viewModel.selectedBeach else { return }
                let coords = beach.coordinates
                let placemark = MKPlacemark(coordinate: coords)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = viewModel.beachName
                mapItem.openInMaps()
            }
            .accessibilityLabel("Get directions to \(viewModel.beachName)")
            .accessibilityHint("Opens Apple Maps")
            Spacer()
            ActionButton(icon: "phone.fill", title: "Call") {
                guard let beach = viewModel.selectedBeach else { return }
                
                let cleanedPhone = beach.phoneNumber.filter { "0123456789".contains($0) }
                
                if let url = URL(string: "tel://\(cleanedPhone)") {
                    UIApplication.shared.open(url)
                }
            }
            .accessibilityLabel("Call \(viewModel.beachName)")
            .accessibilityHint("Opens the phone dialer")
        }
        .padding()
    }
}

#Preview {
    ContactWebsitePhone()
}
