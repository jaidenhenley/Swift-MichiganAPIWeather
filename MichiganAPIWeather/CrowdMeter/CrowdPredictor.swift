//
//  CrowdPredictor.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/1/26.
//

import CoreML
import Foundation

class CrowdPredictor {
    private let model = try? BeachCrowdClassifier_weather(configuration: MLModelConfiguration())
        
    func predict(for date: Date, tempMax: Double, tempMin: Double, precipitation: Double, windMax: Double, waterTemp: Double?) -> CrowdLevel {
        let cal = Calendar.current
        let month = cal.component(.month, from: date)
        let dow = cal.component(.weekday, from: date) - 1
        let isWeekend = dow == 0 || dow == 6
        let season = seasonFrom(month: month)
        let isGoodWeather = precipitation == 0 && tempMax > 65 ? 1.0 : 0.0

        let tempScore = min(max((tempMax - 32) / (100 - 32), 0), 1)
        let precipScore = 1.0 - min(precipitation / 20.0, 1)
        let windScore = 1.0 - min(windMax / 40.0, 1)
        // Match Python weather_multiplier logic exactly
        var m = 1.0
        if tempMax < 50 {
            m *= max(0.35, tempMax / 50.0)
        } else if tempMax < 60 {
            m *= 0.6 + (tempMax - 50) * 0.03
        } else if tempMax <= 85 {
            m *= 1.0 + 0.25 * ((tempMax - 60) / 25.0)
        } else {
            m *= max(0.75, 1.0 - (tempMax - 85) * 0.012)
        }

        if precipitation > 0 {
            m *= max(0.15, 1.0 - precipitation * 0.35)
        }

        if windMax > 15 {
            m *= max(0.35, 1.0 - (windMax - 15) * 0.03)
        }

        let weatherScore = min(m, 1.5) * 100
        // Order must match training: month, day_of_week, is_weekend, is_holiday, season,
        // temp_max, precipitation, wind_max, is_good_weather, weather_score
        let values: [Float] = [
            Float(month), Float(dow), Float(isWeekend ? 1 : 0), 0.0,
            Float(season), Float(tempMax), Float(precipitation),
            Float(windMax), Float(isGoodWeather), Float(weatherScore)
        ]

        guard let multiArray = try? MLMultiArray(shape: [1, 10], dataType: .float32) else { return .medium }
        for (i, v) in values.enumerated() {
            multiArray[i] = NSNumber(value: v)
        }

        let input = BeachCrowdClassifier_weatherInput(input: multiArray)
        guard let result = try? model?.prediction(input: input),
              let classIndex = result.featureValue(for: "var_98")?.multiArrayValue?[0] else { return .medium }

        return CrowdLevel(rawValue: Int(classIndex.int32Value)) ?? .medium
    }

    private func seasonFrom(month: Int) -> Int {
        switch month {
        case 12, 1, 2: return 0
        case 3, 4, 5: return 1
        case 6, 7, 8: return 2
        default: return 3
        }
    }
}

private func date(_ month: Int, _ day: Int) -> Date {
    var components = DateComponents()
    components.year = 2024
    components.month = month
    components.day = day
    return Calendar.current.date(from: components) ?? Date()
}

enum CrowdLevel: Int {
    case low = 0, medium = 1, high = 2
    
    var label: String {
        switch self {
        case .low: return "Not Busy"
        case .medium: return "Moderate"
        case .high: return "Busy"
        }
    }
}

func debugModel() {
    if let model = try? BeachCrowdClassifier_weather(configuration: MLModelConfiguration()) {
        print(model.model.modelDescription.inputDescriptionsByName)
        print(model.model.modelDescription.outputDescriptionsByName)
    }
}

func testCrowdModel() {
    let labels = ["Low", "Medium", "High"]
    var passed = 0

    // (name, date, tempMax, tempMin, precip, windMax, waterTemp, expected)
    let tests: [(String, Date, Double, Double, Double, Double, Double?, Int)] = [
        // High - strong "go to the beach" days
        ("Late May holiday heat",     date(5,26), 82, 63, 0,  8,  54.0, 2),
        ("Early June sunny hot",      date(6,1),  81, 61, 0,  7,  56.0, 2),
        ("June Saturday beach day",   date(6,7),  84, 64, 0,  9,  59.0, 2),
        ("June Sunday hot calm",      date(6,15), 85, 66, 0,  6,  61.0, 2),
        ("Late June perfect",         date(6,27), 86, 67, 0,  8,  65.0, 2),
        ("July Monday very hot",      date(7,7),  88, 69, 0,  7,  71.0, 2),
        ("July lake day",             date(7,10), 87, 68, 0,  8,  72.0, 2),
        ("Mid July peak summer",      date(7,15), 90, 71, 0,  6,  73.0, 2),
        ("July weekend scorcher",     date(7,19), 91, 72, 0,  5,  74.0, 2),
        ("Late July hot calm",        date(7,26), 89, 70, 0,  7,  75.0, 2),
        ("Early August beach heat",   date(8,2),  88, 69, 0,  8,  74.0, 2),
        ("August Saturday peak heat", date(8,9),  92, 73, 0,  5,  76.0, 2),
        ("August Sunday perfect",     date(8,10), 86, 68, 0,  7,  75.0, 2),
        ("Mid August hot and dry",    date(8,15), 90, 72, 0,  6,  74.0, 2),
        ("Late August summer hold",   date(8,23), 85, 67, 0,  8,  72.0, 2),
        ("August Friday ideal",       date(8,29), 84, 66, 0,  9,  70.0, 2),
        ("Labor Day Sunday hot",      date(8,31), 87, 68, 0,  7,  71.0, 2),
        ("June Friday sunny",         date(6,13), 83, 63, 0,  9,  60.0, 2),
        ("July Thursday hot",         date(7,17), 88, 69, 0,  6,  72.0, 2),
        ("August Tuesday beach",      date(8,5),  86, 67, 0,  8,  73.0, 2),

        // Medium - acceptable but clearly not elite
        ("Late May decent",           date(5,31), 71, 53, 0,  12, 51.0, 1),
        ("Early June mixed sun",      date(6,3),  73, 56, 0,  14, 55.0, 1),
        ("June Monday average",       date(6,9),  74, 57, 1,  13, 58.0, 1),
        ("June cloudy but warm",      date(6,18), 75, 58, 4,  12, 61.0, 1),
        ("June breezy mild",          date(6,24), 72, 55, 0,  18, 60.0, 1),
        ("July not bad",              date(7,2),  78, 61, 2,  15, 67.0, 1),
        ("July partly cloudy",        date(7,9),  76, 60, 3,  14, 68.0, 1),
        ("July breezy warm",          date(7,16), 77, 59, 0,  19, 69.0, 1),
        ("July humid average",        date(7,21), 79, 63, 1,  16, 76.0, 1),
        ("Late July cloudy",          date(7,28), 75, 60, 5,  15, 72.0, 1),
        ("Early August average",      date(8,6),  77, 61, 0,  14, 70.0, 1),
        ("August cloudy warm",        date(8,12), 74, 59, 6,  13, 71.0, 1),
        ("August breezy",             date(8,20), 73, 57, 0,  20, 69.0, 1),
        ("Late August mild",          date(8,27), 72, 56, 0,  14, 66.0, 1),
        ("Early September decent",    date(9,3),  73, 55, 0,  13, 62.0, 1),
        ("September warmish",         date(9,7),  75, 58, 0,  12, 63.0, 1),
        ("September cloudy",          date(9,13), 70, 54, 5,  15, 64.0, 1),
        ("September breezy cool",     date(9,18), 67, 51, 0,  18, 59.0, 1),
        ("Late May overcast",         date(5,18), 68, 50, 4,  16, 49.0, 1),
        ("June Friday okay",          date(6,20), 76, 58, 0,  15, 62.0, 1),

        // Low - aggressive rejection days
        ("Early April raw cold",      date(4,3),  49, 34, 2,  22, 39.0, 0),
        ("April wet and windy",       date(4,6),  47, 36, 11, 30, 42.0, 0),
        ("April lakefront misery",    date(4,11), 45, 33, 6,  32, 40.0, 0),
        ("Mid April freezing rain",   date(4,16), 44, 31, 13, 27, 38.0, 0),
        ("Late April gray cold",      date(4,22), 51, 37, 5,  21, 43.0, 0),
        ("Early May awful",           date(5,2),  52, 39, 9,  26, 44.0, 0),
        ("May rain and wind",         date(5,8),  55, 41, 12, 29, 46.0, 0),
        ("May cold lake day",         date(5,12), 56, 42, 4,  24, 47.0, 0),
        ("October sharp cold",        date(10,3), 53, 38, 2,  20, 48.0, 0),
        ("October soaked",            date(10,9), 49, 36, 14, 28, 50.0, 0),
        ("October windy misery",      date(10,15),51, 37, 3,  34, 47.0, 0),
        ("Late October ugly",         date(10,24),46, 33, 7,  25, 45.0, 0),
        ("Early November brutal",     date(11,2), 43, 29, 4,  21, 41.0, 0),
        ("November cold rain",        date(11,6), 44, 31, 10, 24, 43.0, 0),
        ("November windy cold",       date(11,10),42, 28, 1,  30, 40.0, 0),
        ("Mid November raw",          date(11,15),41, 27, 5,  23, 39.0, 0),
        ("Late November miserable",   date(11,22),39, 25, 6,  26, 38.0, 0),
        ("Cold spring fakeout",       date(5,1),  50, 38, 0,  22, 43.0, 0),
        ("April Saturday terrible",   date(4,26), 48, 35, 8,  27, 41.0, 0),
        ("October Friday washout",    date(10,17),47, 34, 16, 29, 46.0, 0),
    ]
    let predictor = CrowdPredictor()
    for (name, testDate, tMax, tMin, precip, wind, water, expected) in tests {
        let result = predictor.predict(for: testDate, tempMax: tMax, tempMin: tMin,
                            precipitation: precip, windMax: wind, waterTemp: water)
        let status = result.rawValue == expected ? "✅" : "❌"
        if result.rawValue == expected { passed += 1 }
        print("\(status) \(name): got \(labels[result.rawValue]), expected \(labels[expected])")
    }

    print("\n\(passed)/\(tests.count) tests passed")
}
