//
//  SuggestedBeach.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import Foundation

struct SuggestedBeach {
    let beach: Beach
    let score: Double
    let reason: String
    let type: SuggestionType
}

protocol FavoritesRepository {
    func isFavorite(beachID: Int) -> Bool
    func allFavorites() -> [Beach]
}

enum SuggestionType {
    case today
    case thisWeekend
    case topPick
}
