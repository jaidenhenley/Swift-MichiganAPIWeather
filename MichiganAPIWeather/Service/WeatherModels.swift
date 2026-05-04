//
//  WeatherModels.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

// MARK: - Top Level Response (backend only — no weather fields)

struct BeachDetailResponse: Decodable {
    let beach: String?
    let buoyData: BuoyData?
    let waterQuality: [WaterQuality]?
    let alerts: [AlertFeature]
    let holiday: Bool

    enum CodingKeys: String, CodingKey {
        case beach, alerts, holiday, waterQuality
        case buoyData = "buoyData"
    }
}

struct BeachAlertsResponse: Decodable {
    let waterQuality: [WaterQuality]?
    let alerts: [AlertFeature]?
}

// MARK: - Buoy

struct BuoyData: Decodable {
    let source: String
    let stationId: String?
    let waterTempC: Double?
    let waveHeightM: Double?
    let wavePeriodSec: Double?
    let windSpeedMph: Double?
    let windDirection: String?
    let timestamp: String?

    enum CodingKeys: String, CodingKey {
        case source, timestamp
        case stationId = "station_id"
        case waterTempC = "water_temp_c"
        case waveHeightM = "wave_height_m"
        case wavePeriodSec = "wave_period_sec"
        case windSpeedMph = "wind_speed_mph"
        case windDirection = "wind_direction"
    }
}

// MARK: Water Quality

struct WaterQuality: Decodable {
    let lastReading: String
    let value: Double
    let unit: String
    let status: String
    let source: String
}

// MARK: - Alerts

struct AlertFeature: Decodable {
    let event: String
    let headline: String
    let severity: String
    let urgency: String
    let effective: String
    let expires: String
}

// MARK: - Holiday

struct Holiday: Decodable {
    let name: String?
    let date: String?
}
