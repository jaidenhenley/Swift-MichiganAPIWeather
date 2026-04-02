//
//  CrowdPredictor.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/1/26.
//

import CoreML
import Foundation

class CrowdPredictor {
    private let model = try? BeachCrowdClassifier(configuration: MLModelConfiguration())
    

    func predict(for date: Date, tempMax: Double, tempMin: Double, precipitation: Double, windMax: Double, waterTemp: Double?) -> CrowdLevel {
        let cal = Calendar.current
        let month = cal.component(.month, from: date)
        let dow = cal.component(.weekday, from: date) - 1
        let isWeekend = dow == 0 || dow == 6
        let season = seasonFrom(month: month)
        let isGoodWeather = precipitation == 0 && tempMax > 65 ? 1 : 0

        // Composite weather score: normalized 0–100 combining temp, precip, and wind
        let tempScore = min(max((tempMax - 32) / (100 - 32), 0), 1)
        let precipScore = 1.0 - min(precipitation / 20.0, 1)
        let windScore = 1.0 - min(windMax / 40.0, 1)
        let weatherScore = (tempScore * 0.5 + precipScore * 0.3 + windScore * 0.2) * 100

        guard let provider = try? MLDictionaryFeatureProvider(dictionary: [
            "month": Double(month),
            "day_of_week": Double(dow),
            "is_weekend": Double(isWeekend ? 1 : 0),
            "is_holiday": 0.0,
            "season": Double(season),
            "temp_max": tempMax,
            "precipitation": precipitation,
            "wind_max": windMax,
            "is_good_weather": Double(isGoodWeather),
            "weather_score": weatherScore
        ]),
              let result = try? model?.model.prediction(from: provider),
              let crowdValue = result.featureValue(for: "crowdLevel")?.int64Value else { return .medium }

        return CrowdLevel(rawValue: Int(crowdValue)) ?? .medium
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

func testCrowdModel() {
    let labels = ["Low", "Medium", "High"]
    var passed = 0

    // (name, date, tempMax, tempMin, precip, windMax, waterTemp, expected)
    let tests: [(String, Date, Double, Double, Double, Double, Double?, Int)] = [
        // High
        ("July 4th hot sunny",        date(7,4),  88, 68, 0,  8,  72.0, 2),
        ("July Saturday warm",        date(7,13), 82, 65, 0,  10, 70.0, 2),
        ("August Sunday hot",         date(8,3),  85, 67, 0,  7,  71.0, 2),
        ("June Friday warm",          date(6,6),  78, 60, 0,  12, 58.0, 2),
        ("July Tuesday warm",         date(7,8),  83, 64, 0,  9,  69.0, 2),
        ("Labor Day weekend",         date(8,30), 84, 66, 0,  8,  70.0, 2),
        ("July 4th weekend Sunday",   date(7,6),  86, 67, 0,  9,  72.0, 2),
        ("Hot August Saturday",       date(8,16), 89, 70, 0,  6,  73.0, 2),
        ("Memorial Day weekend",      date(5,24), 80, 62, 0,  10, 52.0, 2),
        ("July Friday afternoon",     date(7,18), 84, 65, 0,  11, 71.0, 2),

        // Medium
        ("June Wednesday mild",       date(6,11), 72, 55, 0,  14, 57.0, 1),
        ("May Saturday cool",         date(5,17), 65, 48, 2,  18, 48.0, 1),
        ("Sept Friday mild",          date(9,5),  74, 57, 0,  11, 63.0, 1),
        ("August Thursday cloudy",    date(8,14), 73, 58, 4,  15, 69.0, 1),
        ("June Tuesday warm",         date(6,17), 76, 59, 0,  13, 60.0, 1),
        ("Sept Saturday cool",        date(9,20), 68, 52, 0,  16, 58.0, 1),
        ("July Wednesday rainy",      date(7,23), 74, 61, 8,  20, 68.0, 1),
        ("Aug Monday mild",           date(8,11), 75, 60, 0,  12, 70.0, 1),
        ("June Saturday windy",       date(6,21), 70, 54, 0,  28, 59.0, 1),
        ("May Sunday warm",           date(5,25), 72, 56, 0,  14, 50.0, 1),

        // Low
        ("April Wednesday cold",      date(4,9),  52, 38, 3,  20, 41.0, 0),
        ("Nov Tuesday cold",          date(11,4), 45, 33, 2,  18, 43.0, 0),
        ("April Monday rainy",        date(4,14), 48, 35, 15, 25, 40.0, 0),
        ("Oct Tuesday cold rainy",    date(10,7), 50, 37, 10, 24, 50.0, 0),
        ("April Thursday windy",      date(4,17), 50, 36, 0,  35, 41.0, 0),
        ("Nov Wednesday cold",        date(11,12),42, 30, 4,  22, 42.0, 0),
        ("Oct Friday cold rainy",     date(10,10),48, 34, 12, 26, 49.0, 0),
        ("May Monday cold rainy",     date(5,5),  54, 40, 14, 28, 45.0, 0),
        ("April Saturday cold",       date(4,19), 53, 39, 0,  18, 41.0, 0),
        ("Nov Saturday cold",         date(11,8), 46, 32, 5,  20, 42.0, 0),
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
