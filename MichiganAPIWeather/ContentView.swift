//
//  ContentView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import CoreLocation
import SwiftUI

struct ContentView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    
    @State private var manager = NavigationManager()
    
    var body: some View {
        
        TabView(selection: $manager.selectedTab) {
            NavigationStack(path: $manager.path) {
                DashboardView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .beachDetail(let beachID):
                            if let beach = Beach.allBeaches.first(where: {  $0.id == beachID }) {
                                BeachView(beach: beach, beachID: beachID)
                            }
                        case .weatherDetail:
                            WeatherDetailView()
                        }
                    }
            }
            .tabItem {
                Label("Plan", systemImage: "water.waves")
            }
            .tag(AppTab.plan)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(AppTab.map)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(AppTab.favorites)
        }
        .environment(manager)
    }
}
