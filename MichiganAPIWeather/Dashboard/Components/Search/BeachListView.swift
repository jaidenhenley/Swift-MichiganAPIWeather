//
//  BeachListView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import CoreLocation
import SwiftData
import SwiftUI

struct BeachListView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    @Environment(\.modelContext) private var context

    @Query private var favorites: [FavoriteBeach]
    
    let beachList: [Beach]
    let sortByDistance: Bool
    let distanceRange: DistanceRange
    
    private var displayedBeaches: [Beach] {
        guard let userLocation = locationManager.userLocation else {
            return beachList
        }
        
        guard let bounds = distanceRange.bounds else {
            return beachList
        }
        
        return beachList.filter { beach in
            let distanceMeters = userLocation.distance(from: beach.clLocation)
            let distanceMiles = distanceMeters / 1609.34
            return distanceMiles >= bounds.min && distanceMiles < bounds.max
        }
        
    }
    

    
    var body: some View {
        List(displayedBeaches) { beach in
            ZStack {
                NavigationLink {
                    BeachView(beach: beach, beachID: beach.id)
                } label: {
                    EmptyView()
                }
                .opacity(0)
                
                BeachRow(beach: beach, isFavorited: favorites.contains(where: { $0.beachId == beach.id}))
            }
            .buttonStyle(.plain)
            .swipeActions {
                Button {
                    if let existing = favorites.first(where: { $0.beachId == beach.id }) {
                        context.delete(existing)
                    } else {
                        context.insert(FavoriteBeach(beachId: beach.id))
                    }
                } label: {
                    Label("Favorite", systemImage: "heart")
                }
                .tint(.orange)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .shadow(radius: 8)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .onAppear {
            if sortByDistance && locationManager.userLocation == nil {
                locationManager.requestLocation()
            }
        }
        .overlay {
            if displayedBeaches.isEmpty {
                ContentUnavailableView("No Beaches", image: "water.waves")
            }
        }
    }
}
