//
//  ForecastViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import Combine
import CoreLocation
import Foundation

@MainActor
class ForecastViewModel: ObservableObject {
    @Published var days: [ForecastDay] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let weatherKitService = WeatherKitService()

    func loadForecast(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil

        await weatherKitService.fetchWeather(latitude: latitude, longitude: longitude)

        if let error = weatherKitService.error {
            errorMessage = "Failed to load forecast"
            print("Forecast fetch error: \(error)")
        } else {
            days = weatherKitService.dailyForecast.map { day in
                ForecastDay(
                    name: day.dayName,
                    temp: day.highF,
                    icon: nil,
                    shortForecast: day.condition,
                    sunrise: dateToTime(day.sunrise),
                    sunset: dateToTime(day.sunset),
                    windSpeed: windSpeedToMPH(day.windSpeed),
                    windDirection: angleToDirection(day.windDirection),
                    uvIndex: day.uvIndex
                )
            }
        }

        isLoading = false
    }

    private func dateToTime(_ time: Date?) -> String {
        guard let time else { return "--" }

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time)
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
}
