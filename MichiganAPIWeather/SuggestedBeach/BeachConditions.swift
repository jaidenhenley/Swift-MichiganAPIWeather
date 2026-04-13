//
//  BeachConditions.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import Foundation

struct BeachConditions {
    let current: ConditionSnapshot
    let weekendForecast: ConditionSnapshot
    
    static let `default` = BeachConditions(
            current: ConditionSnapshot(
                tempF: 0,
                windSpeedMPH: 999,
                precipChance: 1.0,
                uvIndex: 0,
                date: .now
            ),
            weekendForecast: ConditionSnapshot(
                tempF: 0,
                windSpeedMPH: 999,
                precipChance: 1.0,
                uvIndex: 0,
                date: .now
            )
        )
}
