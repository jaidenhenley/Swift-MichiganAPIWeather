//
//  BeachViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation
import Combine

@MainActor
class BeachViewModel: ObservableObject {
    @Published var beachName: String = ""
    @Published var condition: String = ""
    @Published var temperatureDisplay: String = ""
    @Published var windMPH: String = ""
    @Published var windDirection: String = ""
    @Published var humidity: String = ""
    @Published var visibility: String = ""
    @Published var dewpoint: String?
    @Published var pressure: String?
    @Published var stationName: String?
    @Published var lastUpdated: String?
    @Published var forecastDays: [ForecastDay] = []
    @Published var activeAlerts: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var useCelsius: Bool = false
    

    /// Whether we have successfully loaded data at least once
    var hasData: Bool { !beachName.isEmpty }

    private let service = MichiganWaterAPIService()
    private var rawTempCelsius: Double?

    func toggleUnit() {
        useCelsius.toggle()
        updateTemperatureDisplay()
    }

    func loadBeach(id: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchBeachDetails(beachID: id)

            beachName = response.beach
            activeAlerts = response.alerts.features.count

            guard let observation = response.weather.features.first?.properties else {
                errorMessage = "No weather data available"
                isLoading = false
                return
            }

            condition = observation.textDescription
            stationName = observation.stationName
            lastUpdated = formatTimestamp(observation.timestamp)

            // Store raw Celsius for unit toggling
            rawTempCelsius = observation.temperature.value
            updateTemperatureDisplay()

            // Wind speed: API returns km/h
            if let speedKMH = observation.windSpeed.value {
                let mph = speedKMH * 0.621371
                windMPH = String(format: "%.1f mph", mph)
            } else {
                windMPH = "--"
            }

            // Wind direction
            if let degrees = observation.windDirection.value {
                windDirection = degreesToCompass(degrees)
            } else {
                windDirection = "--"
            }

            // Humidity
            if let rh = observation.relativeHumidity.value {
                humidity = "\(Int(rh))%"
            } else {
                humidity = "--"
            }

            // Visibility: API returns meters
            if let meters = observation.visibility.value {
                let miles = meters / 1609.34
                visibility = String(format: "%.1f mi", miles)
            } else {
                visibility = "--"
            }

            // Dewpoint
            if let dpC = observation.dewpoint.value {
                let dpF = (dpC * 9.0 / 5.0) + 32.0
                dewpoint = useCelsius ? "\(Int(dpC))°C" : "\(Int(dpF))°F"
            } else {
                dewpoint = nil
            }

            // Barometric pressure
            if let pa = observation.barometricPressure?.value {
                let hpa = pa / 100.0
                pressure = String(format: "%.1f hPa", hpa)
            } else {
                pressure = nil
            }

            // Forecast
            forecastDays = response.forecast.properties.periods.compactMap { period in
                guard let iconURL = URL(string: period.icon) else { return nil }
                return ForecastDay(
                    name: period.name,
                    temp: period.temperature,
                    icon: iconURL,
                    shortForecast: period.shortForecast
                )
            }

        } catch {
            if !hasData {
                errorMessage = "Couldn't load beach data"
            }
            print("Beach fetch error: \(error)")
        }

        isLoading = false
    }

    // MARK: - Helpers

    private func updateTemperatureDisplay() {
        guard let tempC = rawTempCelsius else {
            temperatureDisplay = "--"
            return
        }
        if useCelsius {
            temperatureDisplay = "\(Int(tempC))°C"
        } else {
            let tempF = (tempC * 9.0 / 5.0) + 32.0
            temperatureDisplay = "\(Int(tempF))°F"
        }
    }

    private func formatTimestamp(_ iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: iso) else {
            // Try without fractional seconds
            formatter.formatOptions = [.withInternetDateTime]
            guard let date = formatter.date(from: iso) else { return iso }
            return RelativeDateTimeFormatter().localizedString(for: date, relativeTo: .now)
        }
        return RelativeDateTimeFormatter().localizedString(for: date, relativeTo: .now)
    }

    private func degreesToCompass(_ degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((degrees + 11.25) / 22.5) % 16
        return directions[index]
    }
}
