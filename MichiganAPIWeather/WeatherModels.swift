//
//  Weather.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

// MARK: - Top Level Response


struct BeachDetailResponse: Codable {
    let beach: String
    let weather: WeatherCollection
    let buoy: BuoyData?
    let alerts: AlertCollection
    let forecast: ForecastResponse
}

// MARK: - Weather
struct ForecastResponse: Codable {
    let properties: ForecastProperties
}

struct ForecastProperties: Codable {
    let periods: [Forecast]
}

struct WeatherCollection: Codable {
    let features: [WeatherFeature]
}

struct WeatherFeature: Codable {
    let properties: WeatherProperties
}

struct WeatherProperties: Codable {
    let stationName: String
    let timestamp: String
    let textDescription: String
    let temperature: WeatherMeasurement
    let dewpoint: WeatherMeasurement
    let windDirection: WeatherMeasurement
    let windSpeed: WeatherMeasurement
    let windGust: WeatherMeasurement?
    let windChill: WeatherMeasurement?
    let heatIndex: WeatherMeasurement?
    let barometricPressure: WeatherMeasurement?
    let visibility: WeatherMeasurement
    let relativeHumidity: WeatherMeasurement
    let cloudLayers: [CloudLayer]?
}

struct WeatherMeasurement: Codable {
    let unitCode: String
    let value: Double?
}

struct CloudLayer: Codable {
    let base: WeatherMeasurement
    let amount: String
}

// MARK: - Alerts

struct AlertCollection: Codable {
    let features: [AlertFeature]
    let title: String?
}

struct AlertFeature: Codable {
    // Add properties here if the API ever returns active alerts
    // For now this just keeps the array decodable when empty
}

// MARK: - Buoy (nullable, not always available)

struct BuoyData: Codable {
    // Fill this in if/when the API starts returning buoy data
}
