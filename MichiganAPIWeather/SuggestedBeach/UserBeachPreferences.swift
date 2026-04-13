//
//  UserBeachPreferances.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import SwiftData
import Foundation

@Model
class UserBeachPreferences {
    var crowdTolerance: CrowdTolerance
    var amenities: [String]
    var maxDistance: Double
    
    init(
        crowdTolerance: CrowdTolerance = .moderate,
        amenities: [String] = [],
        maxDistance: Double = 50
    ) {
        self.crowdTolerance = crowdTolerance
        self.amenities = amenities
        self.maxDistance = maxDistance
    }
    
    static let `default` = UserBeachPreferences()
    
    
}

enum CrowdTolerance: String, Codable, CaseIterable {
    case quiet = "quiet"
    case moderate = "moderate"
    case busy = "busy"
    
    var label: String {
        switch self {
        case .quiet: return "I prefer quiet beaches"
        case .moderate: return "Doesn't matter"
        case .busy: return "I like a lively beach"
        }
    }
}
