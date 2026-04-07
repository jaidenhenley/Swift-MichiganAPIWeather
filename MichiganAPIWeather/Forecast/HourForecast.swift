//
//  HourForecast.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/7/26.
//

import Foundation

struct HourForecast: Identifiable, Hashable {
    let id = UUID()
    let time: String
    let icon: String
    let temp: String
    
}
