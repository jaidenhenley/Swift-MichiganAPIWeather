//
//  CoastCastActivity.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import ActivityKit

struct BeachActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var crowdLevel: String
        var waterTemp: String
        var uvIndex: Int
    }

    let beachName: String
}
