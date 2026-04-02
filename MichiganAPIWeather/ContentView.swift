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

struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var favorites = FavoritesManager()

    private let beaches: [BeachEntry] = [
        BeachEntry(id: 1, name: "Belle Isle Beach", region: "Southeast", iconName: "building.2"),
        BeachEntry(id: 2, name: "Grand Haven State Park", region: "West", iconName: "leaf"),
        BeachEntry(id: 3, name: "Silver Lake Beach", region: "West", iconName: "sparkles"),
        BeachEntry(id: 4, name: "Sleeping Bear Dunes", region: "Northwest", iconName: "mountain.2"),
        BeachEntry(id: 5, name: "Tawas Point State Park", region: "Northeast", iconName: "bird"),
    ]

    private var filteredBeaches: [BeachEntry] {
        if searchText.isEmpty {
            return beaches
        }
        return beaches.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.region.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var favoriteBeaches: [BeachEntry] {
        filteredBeaches.filter { favorites.isFavorite($0.id) }
    }

    private var nonFavoriteBeaches: [BeachEntry] {
        filteredBeaches.filter { !favorites.isFavorite($0.id) }
    }

    private var regions: [String] {
        let allRegions = nonFavoriteBeaches.map(\.region)
        return Array(Set(allRegions)).sorted()
    }

    var body: some View {
        DashboardView()
    }
}
