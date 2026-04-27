//
//  ScoringWeight.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/24/26.
//

import Foundation

struct ScoringWeights {
    // Weather
    var tempHot: Double = 25        // 80+
    var tempWarm: Double = 20       // 75-79
    var tempMild: Double = 15       // 70-74
    var tempCool: Double = 8        // 65-69
    
    var windCalm: Double = 25       // 0-9
    var windLight: Double = 18      // 10-14
    var windModerate: Double = 10   // 15-19
    var windStrong: Double = 4      // 20-24
    
    var precipLow: Double = 25      // 0-19%
    var precipMild: Double = 15     // 20-39%
    var precipModerate: Double = 8  // 40-59%
    var precipHigh: Double = 2      // 60-79%
    
    var uvComfortable: Double = 15  // 3-7
    var uvHigh: Double = 8          // 8-9
    
    var weekendBonus: Double = 10
    
    // Favorites
    var favorite: Double = 15
    var withinTravelLimit: Double = 20
    var amenityMatchPerTag: Double = 5
    
    // Crowd Busyness preference
    var crowdQuiet: Double = 10
    var crowdModerate: Double = 0
    var crowdBusy: Double = -10
    
    static let `default` = ScoringWeights()
}
