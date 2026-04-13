//
//  BeachConditions.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import Foundation

struct BeachConditions {
    let tempF: Double
    let windSpeedMPH: Double
    let precipChance: Double
    let uvIndex: Int
    let isWeekend: Bool
    
    static let `default` = BeachConditions(
        tempF: 0,
        windSpeedMPH: 999,   // falls into default: return 0
        precipChance: 1.0,
        uvIndex: 0,
        isWeekend: false
    )
}
