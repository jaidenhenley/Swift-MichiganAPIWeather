//
//  BeachEntry.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import WidgetKit
import Foundation

struct BeachWidgetEntry: TimelineEntry {
    let date: Date
    let beachName: String
    let waterTemp: String
    let crowdLevel: String
    let uvIndex: Int
    let condition: String
}
