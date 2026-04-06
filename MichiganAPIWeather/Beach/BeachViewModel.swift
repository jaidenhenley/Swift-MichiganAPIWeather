//
//  BeachViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation
import Combine
import CoreLocation
import WeatherKit

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
    

    
    enum ViewBeach: CaseIterable {
        case sleepingBear
        case grandHavenStatePark
        case silverLakeBeach
        case belleIsleBeach
        case tawasPointStatePark
        
        var beachID: Int {
            switch self {
            case .sleepingBear:
                return 1
            case .grandHavenStatePark:
                return 2
            case .silverLakeBeach:
                return 3
            case .belleIsleBeach:
                return 4
            case .tawasPointStatePark:
                return 5
            }
        }
        
        var beachCoordinates: CLLocationCoordinate2D {
            switch self {
            case .belleIsleBeach:
                return .init(latitude: 42.3416, longitude: -82.9625)
            case .grandHavenStatePark:
                return .init(latitude: 43.0564, longitude: -86.2545)
            case .silverLakeBeach:
                return .init(latitude: 43.6753, longitude: -86.5214)
            case .sleepingBear:
                return .init(latitude: 44.8779, longitude: -86.0590)
            case .tawasPointStatePark:
                return .init(latitude: 44.2572, longitude: -83.4467)
            }
        }
        
        var beachDescription: String {
            switch self {
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
            }
        }
    }
    
    
    /// Whether we have successfully loaded data at least once
    var hasData: Bool { !beachName.isEmpty }
    
    private let service = MichiganWaterAPIService()
    private var rawTempCelsius: Double?
    
    func toggleUnit() {
        useCelsius.toggle()
    }
    
    func selectBeach(_ beach: ViewBeach, beachID: Int) async {
        selectedBeach = beach
        await loadBeach(id: beachID)
    }
    
    func loadBeach(id: Int) async {
        guard let beach = selectedBeach else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.fetchBeachDetails(beachID: id)
            
            // WeatherKit
            let location = CLLocation(latitude: beach.beachCoordinates.latitude, longitude: beach.beachCoordinates.longitude)
            let weather = try await WeatherService.shared.weather(for: location)
            let current = weather.currentWeather
            
            condition = current.condition.description
            rawTempCelsius = current.temperature.converted(to: .celsius).value
            
            let speedKMH = current.wind.speed.converted(to: .kilometersPerHour).value
            let mph = speedKMH * 0.621371
            windMPH = String(format: "%.1f mph", mph)
            windDirection = degreesToCompass(current.wind.direction.value)
            humidity = "\(Int(current.humidity * 100))%"
            
            let visibilityMiles = current.visibility.converted(to: .miles).value
            visibility = String(format: "%.1f mi", visibilityMiles)
            
            let dpF = (current.dewPoint.converted(to: .fahrenheit).value)
            dewpoint = useCelsius
            ? "\(Int(current.dewPoint.converted(to: .celsius).value))°C"
            : "\(Int(dpF))°F"
            
            pressure = String(format: "%.1f hPa",
                current.pressure.converted(to: .hectopascals).value)
            
            // Forecast from WeatherKit
            forecastDays = weather.dailyForecast.map { day in
                ForecastDay(name: day.date.formatted(.dateTime.weekday(.wide)), temp: Int(day.highTemperature.converted(to: .fahrenheit).value), icon: nil, shortForecast: day.condition.description)
            }
            
        } catch {
            if !hasData {
                errorMessage = "Couldn't load beach data"
            }
            print("Beach fetch error: \(error)")
        }
        
        isLoading = false
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
