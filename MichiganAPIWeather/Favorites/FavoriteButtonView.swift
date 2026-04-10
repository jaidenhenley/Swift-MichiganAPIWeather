//
//  FavoriteButtonView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/10/26.
//

import SwiftData
import SwiftUI

struct FavoriteButtonView: View {
    let beach: Beach
    
    @Query private var favorites: [FavoriteBeach]
    @Environment(\.modelContext) private var context
    
    private var isFavorited: Bool {
        favorites.contains { $0.beachId == beach.id }
    }
    
    private var matchedFavorite: FavoriteBeach? {
        favorites.first { $0.beachId == beach.id }
    }
    
    var body: some View {
        Button {
            if let existing = matchedFavorite {
                context.delete(existing)
            } else {
                context.insert(FavoriteBeach(beachId: beach.id))
            }
        } label: {
            Image(systemName: isFavorited ? "heart.fill" : "heart")
        }
    }
}

#Preview {
    FavoriteButtonView(beach: Beach.allBeaches[0])
}
