//
//  Beach.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

struct Beach: Codable, Sendable, Identifiable {
    let id: Int
    let location: String
    let temp: Int
    let conditions: String
    let wind: String
    let humidity: Int
    let visibility: String
    let barometricPressure: String
    let windChill: String
    let buoyData: String
    let alerts: String

    enum CodingKeys: String, CodingKey {
        case id, location, temp, conditions, wind, humidity
        case visibility = "visability"
        case barometricPressure, windChill, buoyData, alerts
    }
}
