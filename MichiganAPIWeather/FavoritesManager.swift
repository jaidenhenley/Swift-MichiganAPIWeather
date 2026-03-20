//
//  FavoritesManager.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/20/26.
//

import Foundation
import Combine

class FavoritesManager: ObservableObject {
    private static let storageKey = "favoriteBeachIDs"

    @Published private(set) var favoriteIDs: Set<Int>

    init() {
        let saved = UserDefaults.standard.array(forKey: Self.storageKey) as? [Int] ?? []
        self.favoriteIDs = Set(saved)
    }

    func isFavorite(_ id: Int) -> Bool {
        favoriteIDs.contains(id)
    }

    func toggle(_ id: Int) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: Self.storageKey)
    }
}
