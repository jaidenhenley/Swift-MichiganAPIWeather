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
                    shortForecast: day.condition
                )
            }
        }

        isLoading = false
    }
}
