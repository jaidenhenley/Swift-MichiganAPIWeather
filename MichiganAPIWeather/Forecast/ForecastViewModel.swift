//
//  ForecastViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import Combine
import Foundation

@MainActor
class ForecastViewModel: ObservableObject {
    @Published var days: [ForecastDay] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = MichiganWaterAPIService()

    func loadForecast(beachID: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchBeachDetails(beachID: beachID)
            let periods = response.forecast.properties.periods

            days = periods.compactMap { period in
                guard let iconURL = URL(string: period.icon) else { return nil }
                return ForecastDay(
                    name: period.name,
                    temp: period.temperature,
                    icon: iconURL,
                    shortForecast: period.shortForecast
                )
            }
        } catch {
            errorMessage = "Failed to load forecast"
            print("Forecast fetch error: \(error)")
        }

        isLoading = false
    }
}
