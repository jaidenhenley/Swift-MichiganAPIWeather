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
    let waterQuality: WaterQuality?
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
    
    var lastReadingDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: lastReading)
    }
    
    var readingAgeInDays: Int? {
        guard let date = lastReadingDate else { return nil }
        return Calendar.current.dateComponents([.day], from: date, to: .now).day
    }
    
    // Show at all — 14 day hard cutoff
    var isRecentEnoughToShow: Bool {
        guard let age = readingAgeInDays else { return false }
        return age <= 14
    }
    
    // High confidence — within 5 days
    var isHighConfidence: Bool {
        guard let age = readingAgeInDays else { return false }
        return age <= 5
    }
    
    var formattedValue: String {
        let formatted = value.formatted(.number.precision(.fractionLength(0)))
        return "\(formatted) \(unit)"
    }
    
    var alertMessage: String? {
        guard let age = readingAgeInDays, isRecentEnoughToShow else { return nil }
        switch age {
        case 0...2:
            let when = age == 0 ? "today" : "\(age) day\(age == 1 ? "" : "s") ago"
            return "E. coli levels exceeded safe thresholds \(when). Avoid water contact."
        case 3...5:
            return "E. coli levels exceeded safe thresholds \(age) days ago. Avoid water contact."
        case 6...14:
            return "E. coli levels exceeded safe thresholds \(age) days ago. Conditions may have changed — check local advisories."
        default:
            return nil
        }
    }
}

// MARK: - Alerts

struct AlertFeature: Decodable {
    let event: String
    let headline: String
    let severity: String
    let urgency: String
    let effective: String
    let expires: String

    var expirationDate: Date? {
        Self.iso8601Formatters
            .lazy
            .compactMap { $0.date(from: expires) }
            .first
    }

    func isActive(at date: Date = .now) -> Bool {
        guard let expirationDate else { return true }
        return expirationDate > date
    }

    private static let iso8601Formatters: [ISO8601DateFormatter] = [
        {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }(),
        {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            return formatter
        }()
    ]
}

// MARK: - Holiday

struct Holiday: Decodable {
    let name: String?
    let date: String?
}
