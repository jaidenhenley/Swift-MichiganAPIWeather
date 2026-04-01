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
        
        // Monthly Lake Michigan averages as fallback
        let monthlyWaterTemp: [Int: Double] = [4:41, 5:48, 6:57, 7:67, 8:70, 9:62, 10:52, 11:43]
        let resolvedWaterTemp = waterTemp ?? monthlyWaterTemp[month] ?? 55.0

        guard let provider = try? MLDictionaryFeatureProvider(dictionary: [
            "month": Double(month),
            "day_of_week": Double(dow),
            "is_weekend": Double(isWeekend ? 1 : 0),
            "is_holiday": 0.0,
            "season": Double(season),
            "temp_max": tempMax,
            "temp_min": tempMin,
            "precipitation": precipitation,
            "wind_max": windMax,
            "is_good_weather": Double(isGoodWeather),
            "water_temp_f": resolvedWaterTemp
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

    let tests: [(String, Date, Double, Double, Double, Double, Double?, Int)] = [
        // (name, date, tempMax, tempMin, precip, windMax, waterTemp, expected)
        ("July 4th hot sunny",   date(7,4),  88, 68, 0, 8,  72.0, 2),
        ("July Saturday warm",   date(7,13), 82, 65, 0, 10, 70.0, 2),
        ("August Sunday hot",    date(8,3),  85, 67, 0, 7,  71.0, 2),
        ("June Friday warm",     date(6,6),  78, 60, 0, 12, 58.0, 2),
        ("July Tuesday warm",    date(7,8),  83, 64, 0, 9,  69.0, 2),
        ("June Wednesday mild",  date(6,11), 72, 55, 0, 14, 57.0, 1),
        ("May Saturday cool",    date(5,17), 65, 48, 2, 18, 48.0, 1),
        ("Sept Friday mild",     date(9,5),  74, 57, 0, 11, 63.0, 1),
        ("April Wednesday cold", date(4,9),  52, 38, 3, 20, 41.0, 0),
        ("Oct Monday cold",      date(10,6), 55, 40, 5, 22, 52.0, 0),
        ("May Wednesday rainy",  date(5,14), 58, 44, 12, 25, 47.0, 0),
        ("Nov Tuesday cold",     date(11,4), 45, 33, 2, 18, 43.0, 0),
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
