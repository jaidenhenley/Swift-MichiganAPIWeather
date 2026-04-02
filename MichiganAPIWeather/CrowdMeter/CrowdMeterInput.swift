//
//  CrowdMeter.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/31/26.
//

import Foundation

struct CrowdMeterInput:Codable {
    var hourOfDay: Int
    var dayOfWeek: Int
    var month: Int
    var airTempC: Double
    var weatherCondition: Int
    var windSpeed: Double
    var precipProb: Double
    var waveHeightM: Double
    var waterTempC: Double
    var hasActiveAlerts: Bool
    var isHoliday: Bool
    var isWeekend: Bool
    var trafficConfidence: Double
}
