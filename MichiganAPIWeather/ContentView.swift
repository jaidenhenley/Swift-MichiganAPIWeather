//
//  ContentView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachEntry: Identifiable, Hashable {
    let id: Int
    let name: String
    let region: String
    let iconName: String
}

// ContentView.swift

struct ContentView: View {
    @State private var beachViewModel = BeachViewModel()

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
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
        .environment(beachViewModel)
    }
}
