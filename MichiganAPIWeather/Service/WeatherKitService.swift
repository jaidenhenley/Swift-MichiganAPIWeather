//
//  WeatherKitService.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/3/26.
//

import Foundation
import WeatherKit
import CoreLocation

struct CurrentWeatherSnapshot: Sendable {
    let temperature: Double          // Celsius
    let condition: String
    let windSpeedMph: Double
    let humidity: Int                // 0–100
    let visibility: Double           // miles
    let dewPoint: Double             // Celsius
    let pressure: Double             // hPa
    let uvIndex: Int
    let chanceOfPrecipitation: Double
}


enum CompassDirection {
    case east
    case eastNortheast
    case eastSoutheast
    case north
    case northNortheast
    case northNorthwest
    case northeast
    case northwest
    case south
    case southSoutheast
    case southSouthwest
    case southeast
    case southwest
    case west
    case westNorthwest
    case westSouthwest
    
    var initials: String {
        switch self {
        case .north:          return "N"
        case .northNortheast: return "NNE"
        case .northeast:      return "NE"
        case .eastNortheast:  return "ENE"
        case .east:           return "E"
        case .eastSoutheast:  return "ESE"
        case .southeast:      return "SE"
        case .southSoutheast: return "SSE"
        case .south:          return "S"
        case .southSouthwest: return "SSW"
        case .southwest:      return "SW"
        case .westSouthwest:  return "WSW"
        case .west:           return "W"
        case .westNorthwest:  return "WNW"
        case .northwest:      return "NW"
        case .northNorthwest: return "NNW"
        }
    }
}

struct DailyForecastSnapshot: Identifiable, Sendable {
    let id = UUID()
    let date: Date
    let dayName: String
    let highF: Int
    let lowF: Int
    let condition: String
    let symbolName: String
    let sunrise: Date?
    let sunset: Date?
    let windSpeed: Measurement<UnitSpeed>
    let windDirection: Measurement<UnitAngle>
    let uvIndex: Int
    let chanceOfPrecipitation: Double
}

struct HourForecastSnapshot: Identifiable, Sendable {
    let id = UUID()
    let time: Date
    let icon: String
    let temp: Measurement<UnitTemperature>
    let uvIndex: Int
    let chanceOfPrecipitation: Double
}

@Observable
class WeatherKitService {
    var current: CurrentWeatherSnapshot?
    var dailyForecast: [DailyForecastSnapshot] = []
    var hourlyForecast: [HourForecastSnapshot] = []
    var isLoading = false
    var error: Error?

    private let service = WeatherService.shared

    /// Fetch current weather + 7-day daily forecast for a coordinate.
    func fetchWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        defer { isLoading = false }

        let location = CLLocation(latitude: latitude, longitude: longitude)

        do {
            let weather = try await service.weather(for: location)
            let c = weather.currentWeather

            current = CurrentWeatherSnapshot(
                temperature: c.temperature.converted(to: .celsius).value,
                condition: c.condition.description,
                windSpeedMph: c.wind.speed.converted(to: .milesPerHour).value,
                humidity: Int(c.humidity * 100),
                visibility: c.visibility.converted(to: .miles).value,
                dewPoint: c.dewPoint.converted(to: .celsius).value,
                pressure: c.pressure.converted(to: .hectopascals).value,
                uvIndex: c.uvIndex.value,
                chanceOfPrecipitation: weather.hourlyForecast.first?.precipitationChance ?? 0.0
            )

            dailyForecast = Array(weather.dailyForecast.prefix(10)).map { day in
                DailyForecastSnapshot(
                    date: day.date,
                    dayName: day.date.formatted(.dateTime.weekday(.wide)),
                    highF: Int(day.highTemperature.converted(to: .fahrenheit).value),
                    lowF: Int(day.lowTemperature.converted(to: .fahrenheit).value),
                    condition: day.condition.description,
                    symbolName: day.symbolName,
                    sunrise: day.sun.sunrise,
                    sunset: day.sun.sunset,
                    windSpeed: day.wind.speed,
                    windDirection: day.wind.direction,
                    uvIndex: day.uvIndex.value,
                    chanceOfPrecipitation: day.precipitationChance

                )
            }
            let now = Date()
            
            hourlyForecast = Array(weather.hourlyForecast.filter { $0.date >= now }.prefix(12)).map { hour in
                HourForecastSnapshot(
                    time: hour.date,
                    icon: hour.symbolName,
                    temp: hour.temperature,
                    uvIndex: hour.uvIndex.value,
                    chanceOfPrecipitation: hour.precipitationChance

                )
            }
        } catch {
            self.error = error
            print("WeatherKit fetch error: \(error)")
        }
    }

    /// Raw WeatherKit CurrentWeather for CoreML features.
    func mlFeatures(latitude: Double, longitude: Double) async -> [String: Double]? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let weather = try? await service.weather(for: location) else { return nil }
        let w = weather.currentWeather
        return [
            "temperature": w.temperature.converted(to: .celsius).value,
            "humidity": w.humidity,
            "wind_speed": w.wind.speed.converted(to: .kilometersPerHour).value,
            "uv_index": Double(w.uvIndex.value),
            "visibility": w.visibility.converted(to: .kilometers).value,
            "dew_point": w.dewPoint.converted(to: .celsius).value,
            "pressure": w.pressure.converted(to: .hectopascals).value,
            "condition_code": Double(w.condition.rawValue.hashValue)
        ]
    }
}
