//
//  MapViewCard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/17/26.
//

import SwiftUI
import CoreLocation



struct MapViewCard: View {
    let beach: Beach
    let isSelected: Bool
    var userLocation: CLLocation?
    @Environment(LocationManager.self) var locationManager

    private var driveTimeText: String? {
        guard let userLocation = locationManager.userLocation else { return nil }  // ← use locationManager
        let beachLocation = CLLocation(latitude: beach.coordinates.latitude, longitude: beach.coordinates.longitude)
        let distanceMeters = userLocation.distance(from: beachLocation)
        let miles = distanceMeters / 1609.34
        
        print("Beach: \(beach.beachName) | distanceMeters: \(distanceMeters) | miles: \(miles)")
        
        let minutes = Int((miles / 55.0) * 60.0)
        
        if minutes < 60 {
            return "\(minutes) min away"
        } else {
            let hours = minutes / 60
            let remaining = minutes % 60
            return remaining == 0 ? "\(hours)h away" : "\(hours)h \(remaining)m away"
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(beach.images.first ?? .grandHaven1)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 118)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 14, bottomTrailingRadius: 0, topTrailingRadius: 0))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(beach.beachName)
                    .foregroundStyle(.primary)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if let driveTime = driveTimeText {
                    
                    HStack(spacing: 4) {
                        Image(systemName: "car.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(driveTime)
                            .font(.caption2)
                            .foregroundStyle(.primary)
                    }
                }
                
                HStack(spacing: 4) {
                    if let icon = beach.displayKeywords.first?.icon {
                        Image(systemName: icon)
                            .font(.caption2)
                            .foregroundStyle(.blueGreen)
                    }
                    Text(beach.displayKeywords.first?.label ?? "")
                        .foregroundStyle(.blueGreen)
                        .font(.caption2)
                }
            }
            .padding(10)
            .frame(width: 120, height: 118)
            .onAppear {
                print("User location: \(String(describing: userLocation))")
            }
        }
        .frame(width: 220, height: 118)
        .background(Color(.customWhite))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}



