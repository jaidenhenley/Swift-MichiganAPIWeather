//
//  Beach.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

struct Beach: Codable, Sendable, Identifiable {
    let id: Int
    let name: String
    let county: String
    let latitude: Double
    let longitude: Double
    let lake: String
    let buoyStation: String
    let status: String
    let countryCode: String
}
