//
//  BeachViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Combine
import CoreLocation
import Foundation

// MARK: - Combined model the view consumes

struct BeachDetail {
    let beachName: String
    let buoyData: BuoyData?
    let alerts: [AlertFeature]?
    let traffic: [TrafficData]
    let holiday: [Holiday]?
    let currentWeather: CurrentWeatherSnapshot?
    let dailyForecast: [DailyForecastSnapshot]
}

// MARK: - View Model

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
    @Published var forecastDays: [ForecastDay] = []
    @Published var activeAlerts: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var useCelsius: Bool = false
    @Published var selectedBeach: ViewBeach?

    // Backend-only data
    @Published var buoyData: BuoyData?
    @Published var traffic: [TrafficData] = []
    @Published var holiday: [Holiday]?

    enum ViewBeach: CaseIterable {
        case sleepingBear
        case grandHavenStatePark
        case silverLakeBeach
        case belleIsleBeach
        case tawasPointStatePark

        var beachID: Int {
            switch self {
            case .sleepingBear:         return 1
            case .grandHavenStatePark:  return 2
            case .silverLakeBeach:      return 3
            case .belleIsleBeach:       return 4
            case .tawasPointStatePark:  return 5
            }
        }

        var beachCoordinates: CLLocationCoordinate2D {
            switch self {
            case .belleIsleBeach:        return .init(latitude: 42.3416, longitude: -82.9625)
            case .grandHavenStatePark:   return .init(latitude: 43.0564, longitude: -86.2545)
            case .silverLakeBeach:       return .init(latitude: 43.6753, longitude: -86.5214)
            case .sleepingBear:          return .init(latitude: 44.8779, longitude: -86.0590)
            case .tawasPointStatePark:   return .init(latitude: 44.2572, longitude: -83.4467)
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

    private let apiService = MichiganWaterAPIService()
    private let weatherKitService = WeatherKitService()
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

        let coords = beach.beachCoordinates

        // Fetch backend conditions and WeatherKit in parallel
        async let backendResult = apiService.fetchBeachDetails(beachID: id)
        async let _: Void = weatherKitService.fetchWeather(
            latitude: coords.latitude,
            longitude: coords.longitude
        )

        // Await backend
        do {
            let response = try await backendResult
            beachName = response.beach ?? ""
            buoyData = response.buoyData
            activeAlerts = response.alerts.count
            traffic = response.traffic
            holiday = response.holiday
        } catch {
            if !hasData {
                errorMessage = "Couldn't load beach data"
            }
            print("Backend fetch error: \(error)")
        }

        if let current = weatherKitService.current {
            condition = current.condition
            rawTempCelsius = current.temperature

            windMPH = String(format: "%.1f mph", current.windSpeedMph)
            windDirection = ""
            humidity = "\(current.humidity)%"
            visibility = String(format: "%.1f mi", current.visibility)

            let dpF = current.dewPoint * 9 / 5 + 32
            dewpoint = useCelsius
                ? "\(Int(current.dewPoint))°C"
                : "\(Int(dpF))°F"

            pressure = String(format: "%.1f hPa", current.pressure)
        }

        forecastDays = weatherKitService.dailyForecast.map { day in
            ForecastDay(
                name: day.dayName,
                temp: day.highF,
                icon: nil,
                shortForecast: day.condition
            )
        }

        isLoading = false
    }

    private func degreesToCompass(_ degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((degrees + 11.25) / 22.5) % 16
        return directions[index]
    }
}
