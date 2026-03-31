//
//  Forecast.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import Foundation

struct Forecast: Codable {
    let number: Int
    let name: String
    let startTime: String
    let endTime: String
    let isDaytime: Bool
    let temperature: Int
    let temperatureUnit: String
    let temperatureTrend: String?
    let probabilityOfPrecipitation: PrecipitationValue
    let windSpeed: String
    let windDirection: String
    let icon: String
    let shortForecast: String
    let detailedForecast: String
}

struct PrecipitationValue: Codable {
    let unitCode: String
    let value: Int?
}
