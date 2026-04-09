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

// MARK: - Combined model the view consumes

struct BeachDetail {
    let beachName: String
    let beachImage: ImageResource
    let buoyData: BuoyData?
    let alerts: [AlertFeature]?
    let traffic: [TrafficData]
    let holiday: Bool = false
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
    @Published var hourForecast: [HourForecast] = []
    @Published var activeAlerts: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var useCelsius: Bool = false
    @Published var selectedBeach: ViewBeach?
    @Published var uvIndex: Int = 0
    @Published var chanceOfPrecipitation: Double = 0
    
    // Crowd Meter Data
    @Published var todayCrowd: CrowdLevel?
    @Published var forecastCrowd: [CrowdLevel] = []
    
    let crowdPredictor = CrowdPredictor()
    
    // Backend-only data
    @Published var buoyData: BuoyData?
    @Published var traffic: [TrafficData] = []
    @Published var holiday: Bool = false
    

    enum ViewBeach: CaseIterable {
        case sleepingBear
        case grandHavenStatePark
        case silverLakeBeach
        case belleIsleBeach
        case tawasPointStatePark
        case hollandStatePark
        case ludingtonStatePark
        case pJHoffmasterStatePark
        case warrenDunesStatePark
        case petoskeyStatePark
        case picturedRocksNationalLakeShore
        case presqueIslePark
        case harrisvilleStatePark
        case sterlingStatePark
        case muskegonStatePark
        case saugatuckDunesStatePark
        case southHavenSouthBeach
        case portCrescentStatePark
        case albertESleeperStatePark
        case mclainStatePark
        case porcupineMountainsWildernessStatePark


        var beachID: Int {
            switch self {
            case .sleepingBear:                          return 1
            case .grandHavenStatePark:                   return 2
            case .silverLakeBeach:                       return 3
            case .belleIsleBeach:                        return 4
            case .tawasPointStatePark:                   return 5
            case .hollandStatePark:                      return 6
            case .ludingtonStatePark:                    return 7
            case .pJHoffmasterStatePark:                 return 8
            case .warrenDunesStatePark:                  return 9
            case .petoskeyStatePark:                     return 10
            case .picturedRocksNationalLakeShore:        return 11
            case .presqueIslePark:                       return 12
            case .harrisvilleStatePark:                  return 13
            case .sterlingStatePark:                     return 14
            case .muskegonStatePark:                     return 15
            case .saugatuckDunesStatePark:               return 16
            case .southHavenSouthBeach:                  return 17
            case .portCrescentStatePark:                 return 18
            case .albertESleeperStatePark:               return 19
            case .mclainStatePark:                       return 20
            case .porcupineMountainsWildernessStatePark: return 21
            }
        }


        var beachCoordinates: CLLocationCoordinate2D {
            switch self {
            case .belleIsleBeach:                        return .init(latitude: 42.3416, longitude: -82.9625)
            case .grandHavenStatePark:                   return .init(latitude: 43.0564, longitude: -86.2545)
            case .silverLakeBeach:                       return .init(latitude: 43.6753, longitude: -86.5214)
            case .sleepingBear:                          return .init(latitude: 44.8779, longitude: -86.0590)
            case .tawasPointStatePark:                   return .init(latitude: 44.2572, longitude: -83.4467)
            case .hollandStatePark:                      return .init(latitude: 42.7789, longitude: -86.2048)
            case .ludingtonStatePark:                    return .init(latitude: 44.0349, longitude: -86.5018)
            case .pJHoffmasterStatePark:                 return .init(latitude: 43.1329, longitude: -86.2654)
            case .warrenDunesStatePark:                  return .init(latitude: 41.9153, longitude: -86.5934)
            case .petoskeyStatePark:                     return .init(latitude: 45.4068, longitude: -84.9086)
            case .picturedRocksNationalLakeShore:        return .init(latitude: 46.5643, longitude: -86.3163)
            case .presqueIslePark:                       return .init(latitude: 46.5880, longitude: -87.3818)
            case .harrisvilleStatePark:                  return .init(latitude: 44.6475, longitude: -83.2976)
            case .sterlingStatePark:                     return .init(latitude: 41.9200, longitude: -83.3415)
            case .muskegonStatePark:                     return .init(latitude: 43.2485, longitude: -86.3339)
            case .saugatuckDunesStatePark:               return .init(latitude: 42.6968, longitude: -86.1903)
            case .southHavenSouthBeach:                  return .init(latitude: 42.4031, longitude: -86.2736)
            case .portCrescentStatePark:                 return .init(latitude: 44.0103, longitude: -83.0508)
            case .albertESleeperStatePark:               return .init(latitude: 43.9726, longitude: -83.2055)
            case .mclainStatePark:                       return .init(latitude: 47.2371, longitude: -88.6088)
            case .porcupineMountainsWildernessStatePark: return .init(latitude: 46.7811, longitude: -89.6807)
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
            case .hollandStatePark:
                return "At the mouth of Lake Macatawa where it meets Lake Michigan, Holland State Park is home to one of Michigan's most photographed lighthouses and a wide sandy beach that draws visitors from across the Midwest."
            case .ludingtonStatePark:
                return "Nestled between Hamlin Lake and Lake Michigan, Ludington State Park offers miles of undeveloped shoreline, towering dunes, and some of the clearest freshwater beaches in the state — a true escape from the everyday."
            case .pJHoffmasterStatePark:
                return "Stretching three miles along Lake Michigan's eastern shore, P.J. Hoffmaster State Park is a quiet gem in Muskegon County featuring forested dunes, pristine beaches, and an interpretive center dedicated to the Great Lakes dune ecosystem."
            case .warrenDunesStatePark:
                return "Just 90 minutes from Chicago, Warren Dunes State Park packs dramatic 260-foot dunes, wide sandy beaches, and steady Lake Michigan winds into one of Southwest Michigan's most visited natural areas."
            case .petoskeyStatePark:
                return "Tucked along the shores of Little Traverse Bay, Petoskey State Park is as well known for its petoskey stone hunting along the shoreline as it is for its sweeping views of one of northern Lake Michigan's most beautiful bays."
            case .picturedRocksNationalLakeShore:
                return "Spanning 42 miles of Lake Superior's southern shoreline, Pictured Rocks National Lakeshore is defined by its towering multicolored sandstone cliffs, sea caves, and remote beaches that feel as wild as any coastline in North America."
            case .presqueIslePark:
                return "A 323-acre peninsula jutting into Lake Superior at the edge of Marquette, Presque Isle Park offers rocky shoreline trails, crashing Superior waves, and stunning views of the largest of the Great Lakes in every direction."
            case .harrisvilleStatePark:
                return "One of Michigan's smaller but most charming state parks, Harrisville sits right on the shores of Lake Huron in the heart of the Sunrise Coast — offering a quiet beach, a picturesque harbor, and easy access to the M-23 Heritage Route."
            case .sterlingStatePark:
                return "The only Michigan state park on Lake Erie, Sterling State Park in Monroe offers sandy beaches, calm waters, and some of the best freshwater fishing and birdwatching in the region, just minutes from the Ohio border."
            case .muskegonStatePark:
                return "Sitting between Lake Michigan and Muskegon Lake, Muskegon State Park offers two miles of open Lake Michigan shoreline alongside a mile of calmer lake frontage — giving swimmers, paddlers, and beachcombers plenty of options in one park."
            case .saugatuckDunesStatePark:
                return "A quieter alternative to the busier West Michigan beach towns, Saugatuck Dunes State Park stretches 2.5 miles along Lake Michigan with pristine sand, forested dunes, and 13 miles of trails winding through one of the last undeveloped stretches of the lakeshore."
            case .southHavenSouthBeach:
                return "Framed by South Haven's iconic red lighthouse at the mouth of the Black River, South Beach is one of West Michigan's most beloved summer destinations — offering golden sand, calm swimming waters, and a charming harbor town just steps away."
            case .portCrescentStatePark:
                return "Curving along three miles of sandy Lake Huron shoreline at the tip of Michigan's Thumb, Port Crescent State Park is one of the darkest sky locations in the Lower Peninsula, making it as popular after sunset as it is during the day."
            case .albertESleeperStatePark:
                return "Set among rare dune forest on the shores of Saginaw Bay, Albert E. Sleeper State Park offers a wide sandy beach, four miles of wooded trails, and a peaceful alternative to the busier resort towns of Michigan's Thumb."
            case .mclainStatePark:
                return "Perched on the northern tip of the Keweenaw Peninsula where it meets Lake Superior, McLain State Park offers two miles of remote sandy beach, dramatic Superior sunsets, and a front-row seat to one of the wildest stretches of shoreline in the Great Lakes."
            case .porcupineMountainsWildernessStatePark:
                return "Michigan's largest state park, the Porcupine Mountains stretch along Lake Superior's shore in the remote western Upper Peninsula — offering a rugged Union Bay beach, ancient old-growth forest, and a true wilderness experience unlike anywhere else in the Midwest."
            }
        }

        var beachImage: ImageResource {
            switch self {
            case .sleepingBear:
                    .sleepingBear
            case .grandHavenStatePark:
                    .grandHaven
            case .silverLakeBeach:
                    .silverLake
            case .belleIsleBeach:
                    .belleIsle
            case .tawasPointStatePark:
                    .smallImagePlaceholder
            case .hollandStatePark:
                    .smallImagePlaceholder
            case .ludingtonStatePark:
                    .smallImagePlaceholder
            case .pJHoffmasterStatePark:
                    .smallImagePlaceholder
            case .warrenDunesStatePark:
                    .smallImagePlaceholder
            case .petoskeyStatePark:
                    .smallImagePlaceholder
            case .picturedRocksNationalLakeShore:
                    .smallImagePlaceholder
            case .presqueIslePark:
                    .smallImagePlaceholder
            case .harrisvilleStatePark:
                    .smallImagePlaceholder
            case .sterlingStatePark:
                    .smallImagePlaceholder
            case .muskegonStatePark:
                    .smallImagePlaceholder
            case .saugatuckDunesStatePark:
                    .smallImagePlaceholder
            case .southHavenSouthBeach:
                    .smallImagePlaceholder
            case .portCrescentStatePark:
                    .smallImagePlaceholder
            case .albertESleeperStatePark:
                    .smallImagePlaceholder
            case .mclainStatePark:
                    .smallImagePlaceholder
            case .porcupineMountainsWildernessStatePark:
                    .smallImagePlaceholder
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
