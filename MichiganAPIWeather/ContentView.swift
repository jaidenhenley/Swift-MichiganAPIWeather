//
//  ContentView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachEntry: Identifiable {
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
        NavigationStack {
            List {
                if !favoriteBeaches.isEmpty {
                    Section("Favorites") {
                        ForEach(favoriteBeaches) { beach in
                            beachRow(beach)
                        }
                    }
                }

                ForEach(regions, id: \.self) { region in
                    Section(region) {
                        ForEach(nonFavoriteBeaches.filter { $0.region == region }) { beach in
                            beachRow(beach)
                        }
                    }
                }
            }
            .navigationTitle("Michigan Beaches")
            .searchable(text: $searchText, prompt: "Search beaches or regions")
            .overlay {
                if filteredBeaches.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .onAppear {
                testCrowdModel()
            }
            
        }
        
        
    }

    @ViewBuilder
    private func beachRow(_ beach: BeachEntry) -> some View {
        NavigationLink {
            BeachView(beachID: beach.id, beachName: beach.name)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: beach.iconName)
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(beach.name)
                        .font(.body.weight(.medium))
                    Text(beach.region)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    withAnimation {
                        favorites.toggle(beach.id)
                    }
                } label: {
                    Image(systemName: favorites.isFavorite(beach.id) ? "star.fill" : "star")
                        .foregroundStyle(favorites.isFavorite(beach.id) ? .yellow : .gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
    }
}
