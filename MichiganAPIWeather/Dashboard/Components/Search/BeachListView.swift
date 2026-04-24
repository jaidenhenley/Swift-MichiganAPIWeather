//
//  BeachListView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftData
import SwiftUI

struct BeachListView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    @Environment(\.modelContext) private var context

    @Query private var favorites: [FavoriteBeach]
    
    let beachList: [Beach]
    let sortByDistance: Bool
    
    private var displayedBeaches: [Beach] {
        guard sortByDistance, let userLocation = locationManager.userLocation else {
            return beachList
        }
        return beachList.sortedByDistance(from: userLocation)
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
