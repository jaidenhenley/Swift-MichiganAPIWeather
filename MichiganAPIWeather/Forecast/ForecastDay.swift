//
//  ForecastDay.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import Foundation

struct ForecastDay: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let temp: Int
    let icon: URL?
    let shortForecast: String
    let sunrise: String
    let sunset: String
    let windSpeed: String
    let windDirection: CompassDirection
    let uvIndex: Int
    let chanceOfPrecipitation: Double
}
