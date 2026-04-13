//
//  BeachViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Combine
import CoreLocation
import Foundation
import SwiftUI

// MARK: - View Model

@Observable
@MainActor
class BeachViewModel {
    var beachName: String = ""
    var condition: String = ""
    var temperatureDisplay: String = ""
    var windMPH: String = ""
    var windDirection: String = ""
    var humidity: String = ""
    var visibility: String = ""
    var dewpoint: String?
    var pressure: String?
    var forecastDays: [ForecastDay] = []
    var hourForecast: [HourForecast] = []
    var activeAlerts: Int = 0
    var isLoading: Bool = false
    var errorMessage: String?
    var useCelsius: Bool = false
    var selectedBeach: Beach?
    var uvIndex: Int = 0
    var chanceOfPrecipitation: Double = 0
    
    // Crowd Meter Data
    var todayCrowd: CrowdLevel?
    var forecastCrowd: [CrowdLevel] = []
    
    let crowdPredictor = CrowdPredictor.shared
    
    // Backend-only data
    var buoyData: BuoyData?
    var traffic: [TrafficData] = []
    var holiday: Bool = false
    
    // Search Filtering
    var searchText: String = ""
    
    var isSearching: Bool = false
    
    var filteredBeaches: [Beach] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return Beach.allBeaches }
        return Beach.allBeaches.filter { beach in
            beach.beachName.lowercased().contains(trimmed) ||
            beach.keywords.contains { $0.lowercased().contains(trimmed) }
        }
    }
    

    /// Whether we have successfully loaded data at least once
    var hasData: Bool { !beachName.isEmpty }

    private let apiService = MichiganWaterAPIService()
    private let weatherKitService = WeatherKitService()
    private var rawTempCelsius: Double?

    func toggleUnit() {
        useCelsius.toggle()
    }

    func selectBeach(_ beach: Beach, beachID: Int) async {
        selectedBeach = beach
        await loadBeach(id: beachID)
    }

    func loadBeach(id: Int) async {
        guard let beach = selectedBeach else { return }
        isLoading = true
        errorMessage = nil

        let coords = beach.coordinates

        // Fetch backend conditions and WeatherKit in parallel
        async let backendResult: BeachDetailResponse? = {
            do {
                return try await apiService.fetchBeachDetails(beachID: id)
            } catch {
                print("Backend fetch error: \(error)")
                return nil
            }
        }()
        async let weatherDone: Void = weatherKitService.fetchWeather(
            latitude: coords.latitude,
            longitude: coords.longitude
        )

        // Await both
        let response = await backendResult
        await weatherDone

        // Apply backend data
        if let response {
            beachName = response.beach ?? ""
            buoyData = response.buoyData
            activeAlerts = response.alerts.count
            traffic = response.traffic
            holiday = response.holiday
        } else if !hasData {
            errorMessage = "Couldn't load beach data"
        }

        if let current = weatherKitService.current {
            condition = current.condition
            rawTempCelsius = current.temperature
            
            temperatureDisplay = celsiusToFarenheit(rawTempCelsius!)
            
            windMPH = String(format: "%.1f mph", current.windSpeedMph)
            windDirection = ""
            humidity = "\(current.humidity)%"
            visibility = String(format: "%.1f mi", current.visibility)

            let dpF = current.dewPoint * 9 / 5 + 32
            dewpoint = useCelsius
                ? "\(Int(current.dewPoint))°C"
                : "\(Int(dpF))°F"

            pressure = String(format: "%.1f hPa", current.pressure)
            uvIndex = (current.uvIndex)
            chanceOfPrecipitation = (current.chanceOfPrecipitation)

            print("[WeatherKit] ✅ \(condition)")
            print("[WeatherKit]   Temp: \(temperatureDisplay) (\(String(format: "%.1f", current.temperature))°C)")
            print("[WeatherKit]   Wind: \(windMPH)")
            print("[WeatherKit]   Humidity: \(humidity)")
            print("[WeatherKit]   Visibility: \(visibility)")
            print("[WeatherKit]   Dew Point: \(dewpoint ?? "nil")")
            print("[WeatherKit]   Pressure: \(pressure ?? "nil")")
            print("[WeatherKit]   UV Index: \(current.uvIndex)")
        } else {
            print("[WeatherKit] ❌ No current weather data")
        }

        forecastDays = weatherKitService.dailyForecast.map { day in
            ForecastDay(
                name: day.dayName,
                temp: day.highF,
                icon: day.symbolName,
                shortForecast: day.condition,
                sunrise: dateToTime(day.sunrise),
                sunset: dateToTime(day.sunset),
                windSpeed: windSpeedToMPH(day.windSpeed),
                windDirection: angleToDirection(day.windDirection),
                uvIndex: day.uvIndex,
                chanceOfPrecipitation: day.chanceOfPrecipitation,
                dateText: day.date.formatted(.dateTime.month(.abbreviated).day())

                
            )
        }
        
        hourForecast = weatherKitService.hourlyForecast.map { hour in
            HourForecast(
                time: dateToTime(hour.time),
                icon: hour.icon,
                temp: formatTemp(hour.temp),
                uvIndex: hour.uvIndex,
                chanceOfPrecipitation: hour.chanceOfPrecipitation,
            )
        }

        if forecastDays.isEmpty {
            print("[WeatherKit]   Forecast: empty")
        } else {
            print("[WeatherKit]   Forecast: \(forecastDays.count) day(s)")
            for day in forecastDays {
                print("[WeatherKit]     \(day.name): \(day.temp)°F — \(day.shortForecast)")
            }
        }

        print(forecastCrowd)
        if let response { loadCrowdPredictions(response: response) }
        isLoading = false
    }
    
    func loadCrowdPredictions(response: BeachDetailResponse) {
        print("Load crowd Predictions loaded")
        let waterTemp = buoyData?.waterTempC.map { $0 * 9/5 + 32 }
        
        //Today
        guard let today = weatherKitService.dailyForecast.first else { return }
        print("[Crowd] dailyForecast count: \(weatherKitService.dailyForecast.count)")
        todayCrowd = crowdPredictor.predict(
            for: .now,
            tempMax: Double(today.highF),
            tempMin: Double(today.lowF),
            precipitation: today.chanceOfPrecipitation,
            windMax: today.windSpeed.converted(to: .milesPerHour).value,
            waterTemp: waterTemp,
            isHoliday: response.holiday
        )
        
        //Forecast
        forecastCrowd = weatherKitService.dailyForecast.map { day in
            crowdPredictor.predict(
                for: day.date,
                tempMax: Double(day.highF),
                tempMin: Double(day.lowF),
                precipitation: day.chanceOfPrecipitation,
                windMax: day.windSpeed.converted(to: .milesPerHour).value,
                waterTemp: waterTemp,
                isHoliday: response.holiday
            )
        }
        
        for (i, level) in forecastCrowd.enumerated() {
            let dayName = weatherKitService.dailyForecast[safe: i]?.dayName ?? "Day \(i)"
            print("[Crowd] \(dayName): \(level.label)")
        }
    }
    
    
    func celsiusToFarenheit(_ celsius: Double) -> String {
        
        let fTemp = (celsius * 9/5) + 32
        let fTempRounded = fTemp.rounded()
        let formattedFTemp = fTempRounded.formatted(.number.precision(.fractionLength(0)))
        
        return String("\(formattedFTemp)°")
    }
 
    func dateToTime(_ time: Date!) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let formattedTime = formatter.string(from: time)
        return formattedTime
    }
    
    func formatTemp(_ temp: Measurement<UnitTemperature>) -> String {
        let f = temp.converted(to: .fahrenheit)
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        
        let formattedString = formatter.string(from: f)
        return formattedString
    }
    
    func chanceOfPrecipToPercent(chance: Double) -> String {
        String(format: "%.1f%%", chance * 100)
    }

    
    func windSpeedToMPH(_ speed: Measurement<UnitSpeed>) -> String {
        let windSpeed = speed
        let formatter = MeasurementFormatter()
        
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        
        let formattedSpeed = formatter.string(from: windSpeed)
        return formattedSpeed
    }
    
    func angleToDirection(_ angle: Measurement<UnitAngle>) -> CompassDirection {
        let degrees = angle.converted(to: .degrees).value.truncatingRemainder(dividingBy: 360)
          let normalized = degrees < 0 ? degrees + 360 : degrees

          switch normalized {
          case 348.75..<360, 0..<11.25:   return .north
          case 11.25..<33.75:             return .northNortheast
          case 33.75..<56.25:             return .northeast
          case 56.25..<78.75:             return .eastNortheast
          case 78.75..<101.25:            return .east
          case 101.25..<123.75:           return .eastSoutheast
          case 123.75..<146.25:           return .southeast
          case 146.25..<168.75:           return .southSoutheast
          case 168.75..<191.25:           return .south
          case 191.25..<213.75:           return .southSouthwest
          case 213.75..<236.25:           return .southwest
          case 236.25..<258.75:           return .westSouthwest
          case 258.75..<281.25:           return .west
          case 281.25..<303.75:           return .westNorthwest
          case 303.75..<326.25:           return .northwest
          case 326.25..<348.75:           return .northNorthwest
          default:                        return .north
              
          }
    }
    
    private func degreesToCompass(_ degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((degrees + 11.25) / 22.5) % 16
        return directions[index]
    }
}
