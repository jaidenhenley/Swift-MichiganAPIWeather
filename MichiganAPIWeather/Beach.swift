//
//  Beach.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

class Beach: Codable {
    let location: String
    let temp: Int
    let conditions: String
    let wind: String
    let humidity: Int
    let visability: String
    let barometricPressure: String
    let windChill: String
    let buoyData: String
    let alerts: String
}
