//
//  LocalFavoritesRepositoty.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import Foundation
import SwiftData

struct LocalFavoritesRepository: FavoritesRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func isFavorite(beachID: Int) -> Bool {
        let descriptor = FetchDescriptor<FavoriteBeach>(
            predicate: #Predicate { $0.beachId == beachID }
        )
        return (try? context.fetchCount(descriptor)) ?? 0 > 0
    }

    func allFavorites() -> [Beach] {
        let descriptor = FetchDescriptor<FavoriteBeach>()
        guard let favorites = try? context.fetch(descriptor) else { return [] }
        let favoriteIDs = Set(favorites.map(\.beachId))
        return Beach.allBeaches.filter { favoriteIDs.contains($0.id) }
    }
}

struct NoFavoritesRepository: FavoritesRepository {
    func isFavorite(beachID: Int) -> Bool { false }
    func allFavorites() -> [Beach] { [] }
}
