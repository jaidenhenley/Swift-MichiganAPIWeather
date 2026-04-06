//
//  WeatherKitService.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/3/26.
//

import Foundation
import WeatherKit
import CoreLocation

@Observable
class BeachWeatherService {
    var currentWeather: CurrentWeather?
    var dailyForecast: [DayWeather] = []
    var isLoading = false
    var error: Error?
    
    private let service = WeatherService.shared
    
    func fetchWeather(for beach: BeachViewModel.ViewBeach) async {
        isLoading = true
        defer { isLoading = false }
        
        let location = CLLocation(
            latitude: beach.beachCoordinates.latitude,
            longitude: beach.beachCoordinates.longitude
        )
        
        do {
            let weather = try await service.weather(for: location)
            currentWeather = weather.currentWeather
            dailyForecast = Array(weather.dailyForecast)
        } catch {
            self.error = error
        }
    }
    
    // Mapped for CoreML — match these to your 11 training features
       func mlFeatures() -> [String: Double]? {
           guard let w = currentWeather else { return nil }
           return [
               "temperature": w.temperature.converted(to: .celsius).value,
               "humidity": w.humidity,
               "wind_speed": w.wind.speed.converted(to: .kilometersPerHour).value,
               "uv_index": Double(w.uvIndex.value),
               "visibility": w.visibility.converted(to: .kilometers).value,
               "dew_point": w.dewPoint.converted(to: .celsius).value,
               "pressure": w.pressure.converted(to: .hectopascals).value,
               "condition_code": Double(w.condition.rawValue.hashValue) // placeholder
           ]
       }
}
