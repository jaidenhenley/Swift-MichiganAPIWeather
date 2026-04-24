//
//  DistanceRange.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/23/26.
//

import Foundation

enum DistanceRange: String, CaseIterable, Identifiable {
    case under50 = "< 50"
    case fiftyTo150 = "50-150"
    case oneFiftyTo300 = "150-300"
    case over300 = "300+"
    case all = "All"
    
    var id: String { rawValue }
    
    var bounds: (min: Double, max: Double)? {
        switch self {
        case .under50: return (0, 50)
        case .fiftyTo150: return (50, 150)
        case .oneFiftyTo300: return (150, 300)
        case .over300: return (300, .infinity)
        case .all: return nil
        }
    }
}
