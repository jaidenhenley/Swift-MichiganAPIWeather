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
    @Published var temperatureF: String = ""
    @Published var windMPH: String = ""
    @Published var windDirection: String = ""
    @Published var humidity: String = ""
    @Published var visibility: String = ""
    @Published var activeAlerts: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = MichiganWaterAPIService()
    
    func loadBeach(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.fetchBeachDetails(beachID: id)
            
            beachName = response.beach
            activeAlerts = response.alerts.features.count
            
            // Grab the latest observation from features
            guard let observation = response.weather.features.first?.properties else {
                errorMessage = "No weather data available"
                isLoading = false
                return
            }
            
            condition = observation.textDescription
            
            // API returns Celsius, convert to Fahrenheit
            if let tempC = observation.temperature.value {
                let tempF = (tempC * 9.0 / 5.0) + 32.0
                temperatureF = "\(Int(tempF))°F"
            } else {
                temperatureF = "--"
            }
            
            // API returns km/h, convert to mph
            if let speedKMH = observation.windSpeed.value {
                let mph = speedKMH * 0.621371
                windMPH = "\(Int(mph)) mph"
            } else {
                windMPH = "--"
            }
            
            // Convert degrees to compass direction
            if let degrees = observation.windDirection.value {
                windDirection = degreesToCompass(degrees)
            } else {
                windDirection = "--"
            }
            
            if let rh = observation.relativeHumidity.value {
                humidity = "\(Int(rh))%"
            } else {
                humidity = "--"
            }
            
            // API returns meters, convert to miles
            if let meters = observation.visibility.value {
                let miles = meters / 1609.34
                visibility = "\(Int(miles)) mi"
            } else {
                visibility = "--"
            }
            
        } catch {
            errorMessage = "Couldn't load beach data"
            print("Beach fetch error: \(error)")
        }
        
        isLoading = false
    }
    
    private func degreesToCompass(_ degrees: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
}
