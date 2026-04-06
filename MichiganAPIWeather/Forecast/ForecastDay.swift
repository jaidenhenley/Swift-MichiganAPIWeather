//
//  ForecastDay.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import Foundation

struct ForecastDay: Identifiable {
    let id = UUID()
    let name: String
    let temp: Int
    let icon: URL?
    let shortForecast: String
}
