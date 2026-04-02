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
            Float(windMax), Float(isGoodWeather), Float(weatherScore), Float(waterTemp ?? 65.0)
        ]

        guard let multiArray = try? MLMultiArray(shape: [1, 11], dataType: .float32) else { return .medium }
        for (i, v) in values.enumerated() {
            multiArray[i] = NSNumber(value: v)
        }

        let input = BeachCrowdClassifier_weatherInput(input: multiArray)
        guard let result = try? model?.prediction(input: input) else { return .medium }

        if let output = result.featureValue(for: "output")?.multiArrayValue {
            var maxIndex = 0
            var maxValue = output[0].doubleValue
            for i in 1..<output.count {
                let value = output[i].doubleValue
                if value > maxValue {
                    maxValue = value
                    maxIndex = i
                }
            }
            return CrowdLevel(rawValue: maxIndex) ?? .medium
        }

        if let classIndex = result.featureValue(for: "var_98")?.multiArrayValue?[0] {
            return CrowdLevel(rawValue: Int(classIndex.int32Value)) ?? .medium
        }

        return .medium
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
    case veryLow = 0, low = 1, medium = 2, high = 3, veryHigh = 4
    
    var label: String {
        switch self {
        case .veryLow: return "Very Quiet"
        case .low: return "Not Busy"
        case .medium: return "Moderate"
        case .high: return "Busy"
        case .veryHigh: return "Very Busy"
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
    let labels = ["Very Low", "Low", "Medium", "High", "Very High"]
    var passed = 0
    
    let tests: [(String, Date, Double, Double, Double, Double, Double?, Int)] = [
        ("July 4th scorcher", date(7,4), 92, 73, 0, 5, 74, 4),
        ("August peak heat", date(8,9), 92, 73, 0, 5, 76, 4),
        ("Mid July perfect", date(7,15), 90, 71, 0, 6, 73, 4),
        ("Late July hot calm", date(7,26), 89, 70, 0, 7, 75, 4),
        ("Early August beach heat", date(8,2), 88, 69, 0, 8, 74, 4),
        ("Labor Day hot", date(8,31), 87, 68, 0, 7, 71, 4),
        ("August Sunday perfect", date(8,10), 86, 68, 0, 7, 75, 4),
        ("Late August summer hold", date(8,23), 85, 67, 0, 8, 72, 4),
        ("July Monday very hot", date(7,7), 88, 69, 0, 7, 71, 4),
        ("July weekend scorcher", date(7,19), 91, 72, 0, 5, 74, 4),
        ("August Tuesday beach", date(8,5), 86, 67, 0, 8, 73, 4),
        ("August Friday ideal", date(8,29), 84, 66, 0, 9, 70, 4),
        ("July lake day", date(7,10), 87, 68, 0, 8, 72, 4),
        ("Mid August hot dry", date(8,15), 90, 72, 0, 6, 74, 4),
        ("July Saturday blazing", date(7,12), 93, 74, 0, 4, 75, 4),
        ("August Saturday peak", date(8,16), 91, 72, 0, 5, 76, 4),
        ("Late June perfect", date(6,27), 86, 67, 0, 8, 65, 4),
        ("June Sunday hot calm", date(6,15), 85, 66, 0, 6, 61, 4),
        ("June Saturday beach day", date(6,7), 84, 64, 0, 9, 59, 4),
        ("Early June sunny hot", date(6,1), 81, 61, 0, 7, 56, 4),
        ("Late May holiday heat", date(5,26), 82, 63, 0, 8, 54, 4),
        ("June Friday sunny", date(6,13), 83, 63, 0, 9, 60, 4),
        ("July Thursday hot", date(7,17), 88, 69, 0, 6, 72, 4),
        ("Late May decent warm", date(5,31), 78, 58, 0, 10, 52, 4),
        ("Early June hot weekend", date(6,8), 83, 64, 0, 8, 58, 4),
        ("June Wednesday sunny", date(6,11), 82, 62, 0, 9, 59, 3),
        ("Late June warm", date(6,25), 84, 65, 0, 10, 63, 4),
        ("June Friday okay warm", date(6,20), 80, 61, 0, 11, 62, 4),
        ("Early September warm", date(9,5), 80, 62, 0, 10, 65, 3),
        ("September warm weekend", date(9,6), 82, 63, 0, 9, 64, 4),
        ("Late August warm", date(8,25), 83, 65, 0, 10, 71, 4),
        ("Early July warm", date(7,3), 85, 66, 0, 9, 69, 4),
        ("June cloudy warm", date(6,18), 75, 58, 4, 12, 61, 2),
        ("July not bad", date(7,2), 78, 61, 2, 15, 67, 3),
        ("July partly cloudy", date(7,9), 76, 60, 3, 14, 68, 2),
        ("August cloudy warm", date(8,12), 74, 59, 6, 13, 71, 2),
        ("Late July cloudy", date(7,28), 75, 60, 5, 15, 72, 3),
        ("July light rain", date(7,14), 77, 62, 4, 14, 70, 3),
        ("August drizzle", date(8,18), 76, 60, 5, 13, 69, 3),
        ("June light rain warm", date(6,22), 74, 57, 3, 14, 60, 3),
        ("July humid overcast", date(7,23), 79, 63, 5, 16, 71, 2),
        ("August morning clouds", date(8,7), 75, 59, 2, 13, 70, 3),
        ("September warm cloudy", date(9,10), 74, 57, 4, 14, 63, 1),
        ("Late August overcast", date(8,28), 73, 57, 3, 14, 68, 2),
        ("July windy warm", date(7,22), 80, 63, 0, 22, 72, 4),
        ("August windy", date(8,14), 78, 61, 0, 23, 70, 4),
        ("June windy warm", date(6,16), 76, 59, 0, 21, 61, 4),
        ("Early September cloudy", date(9,3), 73, 55, 3, 13, 62, 0),
        ("Late May decent", date(5,31), 71, 53, 0, 12, 51, 4),
        ("Early June mixed sun", date(6,3), 73, 56, 0, 14, 55, 3),
        ("June breezy mild", date(6,24), 72, 55, 0, 18, 60, 3),
        ("September cloudy cool", date(9,13), 70, 54, 5, 15, 64, 1),
        ("Late May overcast", date(5,18), 68, 50, 4, 16, 49, 1),
        ("September breezy cool", date(9,18), 67, 51, 0, 18, 59, 3),
        ("Early November cold", date(11,2), 43, 29, 4, 21, 41, 1),
        ("Cold spring fakeout", date(5,1), 50, 38, 0, 22, 43, 2),
        ("May cool breezy", date(5,20), 63, 47, 0, 20, 48, 2),
        ("October decent", date(10,5), 62, 46, 0, 16, 50, 4),
        ("Late September cool", date(9,25), 64, 48, 0, 17, 58, 3),
        ("May mild overcast", date(5,15), 65, 49, 3, 15, 47, 0),
        ("October warm day", date(10,2), 65, 48, 0, 14, 51, 2),
        ("Early October mild", date(10,4), 63, 47, 1, 15, 49, 3),
        ("Late September mild", date(9,28), 66, 50, 0, 16, 57, 4),
        ("November mild day", date(11,5), 55, 40, 0, 18, 44, 2),
        ("Early April raw cold", date(4,3), 49, 34, 2, 22, 39, 0),
        ("April wet and windy", date(4,6), 47, 36, 11, 30, 42, 0),
        ("April lakefront misery", date(4,11), 45, 33, 6, 32, 40, 0),
        ("Mid April freezing rain", date(4,16), 44, 31, 13, 27, 38, 0),
        ("Late April gray cold", date(4,22), 51, 37, 5, 21, 43, 0),
        ("Early May awful", date(5,2), 52, 39, 9, 26, 44, 0),
        ("May rain and wind", date(5,8), 55, 41, 12, 29, 46, 0),
        ("May cold lake day", date(5,12), 56, 42, 4, 24, 47, 0),
        ("October sharp cold", date(10,3), 53, 38, 2, 20, 48, 1),
        ("October soaked", date(10,9), 49, 36, 14, 28, 50, 0),
        ("October windy misery", date(10,15), 51, 37, 3, 34, 47, 0),
        ("Late October ugly", date(10,24), 46, 33, 7, 25, 45, 0),
        ("November cold rain", date(11,6), 44, 31, 10, 24, 43, 0),
        ("November windy cold", date(11,10), 42, 28, 1, 30, 40, 2),
        ("Mid November raw", date(11,15), 41, 27, 5, 23, 39, 0),
        ("Late November miserable", date(11,22), 39, 25, 6, 26, 38, 0),
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
