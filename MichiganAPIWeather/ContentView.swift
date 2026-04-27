//
//  ContentView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import CoreLocation
import SwiftUI

struct BeachEntry: Identifiable, Hashable {
    let id: Int
    let name: String
    let region: String
    let iconName: String
}

// ContentView.swift

struct ContentView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager


    var body: some View {
        
        TabView {
            DashboardView()
                .tabItem {
                    Label("Plan", systemImage: "water.waves")
                }

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .onAppear {
            sampleData()
        }
    }
    
    func sampleData() {
        let json = Beach.allBeaches.map { beach in
            [
                "id": beach.id,
                "name": beach.beachName,
                "lat": beach.coordinates.latitude,
                "lon": beach.coordinates.longitude
            ]
        }
        print(String(data: (try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])) ?? Data(), encoding: .utf8) ?? "")
    }
}
