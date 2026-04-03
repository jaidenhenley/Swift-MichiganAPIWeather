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
    @Published var selectedBeach: ViewBeach?
    var beachDescription: String {
        switch selectedBeach {
        case .sleepingBear:
            return "Stretching across 35 miles of Lake Michigan shoreline, Sleeping Bear Dunes National Lakeshore offers towering sand dunes, crystal-clear water, and some of the most scenic views in the Midwest."

        case .grandHavenStatePark:
            return "Sitting at the mouth of the Grand River, Grand Haven State Park is known for its iconic lighthouse, long sandy shoreline, and some of the best sunsets on Lake Michigan."

        case .silverLakeBeach:
            return "Tucked alongside the Silver Lake Sand Dunes, this West Michigan beach is a favorite for off-road dune riding, swimming, and wide-open views of Lake Michigan just over the ridge."

        case .belleIsleBeach:
            return "Right in the heart of Detroit, Belle Isle Beach sits on the island park in the Detroit River and offers a unique urban waterfront experience with views of the city skyline and the Canadian shore."

        case .tawasPointStatePark:
            return "Known as the Sleeping Bear of Lake Huron, Tawas Point State Park features a curved sandy spit, a historic lighthouse, and calm, shallow waters that make it one of Michigan's most family-friendly beaches."
        case .none:
            return "Failed to load"
        }
    }
    
    enum ViewBeach: CaseIterable {
        case sleepingBear
        case grandHavenStatePark
        case silverLakeBeach
        case belleIsleBeach
        case tawasPointStatePark
    }
    

    /// Whether we have successfully loaded data at least once
    var hasData: Bool { !beachName.isEmpty }

    private let service = MichiganWaterAPIService()
    private var rawTempCelsius: Double?

    func toggleUnit() {
        useCelsius.toggle()
        updateTemperatureDisplay()
    }
    
    func selectBeach(_ beach: ViewBeach, beachID: Int) async {
        selectedBeach = beach
        await loadBeach(id: beachID)
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
            
            print("=== Beach Loaded ===")
                    print("Name: \(beachName)")
                    print("Description: \(beachDescription)")
                    print("Condition: \(condition)")
                    print("Temperature: \(temperatureDisplay)")
                    print("Wind: \(windMPH) \(windDirection)")
                    print("Humidity: \(humidity)")
                    print("Visibility: \(visibility)")
                    print("Dewpoint: \(dewpoint ?? "N/A")")
                    print("Pressure: \(pressure ?? "N/A")")
                    print("Station: \(stationName ?? "N/A")")
                    print("Last Updated: \(lastUpdated ?? "N/A")")
                    print("Active Alerts: \(activeAlerts)")
                    print("Forecast Days: \(forecastDays.count)")
                    print("====================")

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
