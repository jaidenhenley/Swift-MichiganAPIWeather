//
//  FavoritesView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/10/26.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    
    @Query private var favorites: [FavoriteBeach]
    
    private var favoriteBeaches: [Beach] {
        let favoriteIDs = Set(favorites.map(\.beachId))
        return Beach.allBeaches.filter { favoriteIDs.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteBeaches.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart.slash",
                        description: Text("Beaches you favorite will show up here.")
                    )
                } else {
                    List(favoriteBeaches) { beach in
                        NavigationLink {
                            BeachView(beach: beach, beachID: beach.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(beach.images[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading) {
                                    Text(beach.beachName)
                                        .font(.headline)
                                    Text(beach.shortDescription)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
