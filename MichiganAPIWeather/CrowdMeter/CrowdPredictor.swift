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
        
    func predict(
        for date: Date,
        tempMax: Double,
        tempMin: Double,
        precipitation: Double,
        windMax: Double,
        waterTemp: Double?
    ) -> CrowdLevel {
        guard let model else { return .medium }

        let cal = Calendar.current
        let month = cal.component(.month, from: date)

        // Match Python training assumptions exactly
        // Python data used 0...6 style day-of-week
        let dow = cal.component(.weekday, from: date) - 1   // Sunday=0 ... Saturday=6
        let isWeekend = (dow == 0 || dow == 6) ? 1.0 : 0.0
        let isHoliday = 0.0
        let tempRange = tempMax - tempMin
        let water = waterTemp ?? 65.0
        let isPeakSummer = (month == 7 || month == 8) ? 1.0 : 0.0

        let monthSin = sin(2.0 * .pi * Double(month) / 12.0)
        let monthCos = cos(2.0 * .pi * Double(month) / 12.0)

        // EXACT feature order from training
        let values: [Float] = [
            Float(monthSin),            // month_sin
            Float(monthCos),            // month_cos
            Float(dow),                 // day_of_week
            Float(isWeekend),           // is_weekend
            Float(isHoliday),           // is_holiday
            Float(tempMax),             // temp_max
            Float(tempMin),             // temp_min
            Float(tempRange),           // temp_range
            Float(precipitation),       // precipitation
            Float(windMax),             // wind_max
            Float(water),               // water_temp_f
            Float(isPeakSummer)         // is_peak_summer
        ]

        guard let multiArray = try? MLMultiArray(shape: [1, 12], dataType: .float32) else {
            return .medium
        }

        for (i, v) in values.enumerated() {
            multiArray[i] = NSNumber(value: v)
        }

        let input = BeachCrowdClassifierInput(features: multiArray)
        guard let result = try? model.prediction(input: input) else {
            return .medium
        }

        // Prefer the class output if present
        if let classIndex = result.featureValue(for: "var_82")?.multiArrayValue?[0] {
            return CrowdLevel(rawValue: Int(classIndex.int32Value)) ?? .medium
        }

        // Fallback: argmax over probabilities
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
    if let model = try? BeachCrowdClassifier(configuration: MLModelConfiguration()) {
        print(model.model.modelDescription.inputDescriptionsByName)
        print(model.model.modelDescription.outputDescriptionsByName)
    }
}

func testCrowdModel() {
    let labels = ["Very Low", "Low", "Medium", "High", "Very High"]
    var passed = 0
    
    // Fields: name, date, tempMax, tempMin, precipitation, windMax, waterTemp, expectedClass
    let tests: [(String, Date, Double, Double, Double, Double, Double?, Int)] = [

        // MARK: - 4 = Clear Best Beach Days
        ("Peak July perfect",           date(7,12), 90, 72, 0, 5, 74, 4),
        ("July 4 holiday scorcher",     date(7,4),  92, 73, 0, 4, 75, 4),
        ("Mid July elite",              date(7,18), 89, 71, 0, 6, 73, 4),
        ("Late July glass calm",        date(7,27), 88, 70, 0, 5, 75, 4),
        ("Early August peak",           date(8,3),  91, 72, 0, 5, 76, 4),
        ("August Saturday ideal",       date(8,9),  87, 69, 0, 7, 74, 4),
        ("Hot sunny July weekday",      date(7,9),  88, 68, 0, 6, 72, 4),
        ("Late June breakout",          date(6,28), 86, 67, 0, 7, 65, 4),
        ("Warm Labor Day weekend",      date(8,30), 86, 68, 0, 7, 71, 4),
        ("Prime beach Sunday",          date(8,17), 89, 70, 0, 6, 75, 4),

        // MARK: - 3 = Good / Strong but not elite
        ("Warm June beach day",         date(6,14), 82, 63, 0, 10, 59, 3),
        ("Hot but a bit breezy",        date(7,16), 85, 66, 0, 12, 71, 3),
        ("Early September warm",        date(9,6),  81, 62, 0, 10, 65, 3),
        ("July partly cloudy good",     date(7,7),  83, 64, 2, 10, 70, 3),
        ("August very warm light wind", date(8,22), 84, 65, 0, 11, 72, 3),
        ("Late June solid",             date(6,21), 81, 62, 0, 11, 61, 3),
        ("July humid but nice",         date(7,24), 84, 67, 1, 10, 73, 3),
        ("August warm weekday",         date(8,12), 82, 64, 0, 12, 71, 3),
        ("Sunny September surprise",    date(9,3),  79, 60, 0, 9, 63, 3),
        ("June good not great",         date(6,8),  80, 61, 0, 12, 58, 3),

        // MARK: - 2 = Borderline / Mixed Signal Days
        ("Warm but windy July",         date(7,20), 82, 64, 0, 19, 72, 2),
        ("Clouds and mild June",        date(6,18), 75, 58, 4, 12, 61, 2),
        ("Late August overcast",        date(8,26), 74, 58, 3, 13, 69, 2),
        ("July light rain",             date(7,14), 77, 61, 4, 13, 70, 2),
        ("Cool but dry September",      date(9,14), 72, 55, 0, 14, 62, 2),
        ("May decent but cool",         date(5,24), 70, 52, 0, 13, 50, 2),
        ("June breezy mild",            date(6,24), 73, 56, 0, 17, 60, 2),
        ("August cloudy okay",          date(8,14), 76, 60, 5, 12, 70, 2),
        ("September cooler but calm",   date(9,21), 69, 53, 0, 11, 59, 2),
        ("Humid cloudy July",           date(7,29), 78, 63, 5, 15, 72, 2),

        // MARK: - 1 = Weak / Probably Not Worth It
        ("Cool May overcast",           date(5,15), 65, 49, 3, 15, 47, 1),
        ("Early October mild",          date(10,4), 63, 47, 1, 15, 49, 1),
        ("Late September cool",         date(9,27), 64, 48, 0, 16, 57, 1),
        ("May breezy and cool",         date(5,20), 63, 47, 0, 20, 48, 1),
        ("October sharp chill",         date(10,8), 58, 43, 0, 16, 50, 1),
        ("Cloudy September drag",       date(9,10), 70, 55, 5, 15, 63, 1),
        ("Cold water June fakeout",     date(6,2),  76, 58, 0, 11, 50, 1),
        ("November mild but dead",      date(11,5), 55, 40, 0, 18, 44, 1),
        ("May gray lake day",           date(5,10), 62, 46, 2, 16, 46, 1),
        ("September windy cool",        date(9,18), 67, 51, 0, 18, 59, 1),

        // MARK: - 0 = Clear Bad Days
        ("Early April raw cold",        date(4,3),  49, 34, 2, 22, 39, 0),
        ("April wet and windy",         date(4,6),  47, 36, 11, 30, 42, 0),
        ("April lakefront misery",      date(4,11), 45, 33, 6, 32, 40, 0),
        ("Mid April freezing rain",     date(4,16), 44, 31, 13, 27, 38, 0),
        ("Late April gray cold",        date(4,22), 51, 37, 5, 21, 43, 0),
        ("Early May awful",             date(5,2),  52, 39, 9, 26, 44, 0),
        ("May rain and wind",           date(5,8),  55, 41, 12, 29, 46, 0),
        ("October soaked",              date(10,9), 49, 36, 14, 28, 50, 0),
        ("Late October ugly",           date(10,24),46, 33, 7, 25, 45, 0),
        ("Late November miserable",     date(11,22),39, 25, 6, 26, 38, 0),

        // MARK: - Edge Cases: same heat, changing one variable
        ("Edge hot calm dry",           date(7,11), 86, 67, 0, 7, 72, 4),
        ("Edge hot windy",              date(7,11), 86, 67, 0, 21, 72, 2),
        ("Edge hot rainy",              date(7,11), 86, 67, 9, 7, 72, 1),
        ("Edge hot cold water",         date(6,5),  86, 67, 0, 7, 49, 1),
        ("Edge warm perfect water",     date(6,5),  78, 60, 0, 7, 72, 3),

        // MARK: - Edge Cases: same setup, changing water temperature
        ("Water edge 48",               date(6,9),  82, 63, 0, 8, 48, 1),
        ("Water edge 54",               date(6,9),  82, 63, 0, 8, 54, 3),
        ("Water edge 62",               date(6,9),  82, 63, 0, 8, 62, 4),

        // MARK: - Edge Cases: same setup, changing wind
        ("Wind edge 8",                 date(7,21), 84, 66, 0, 8, 73, 4),
        ("Wind edge 14",                date(7,21), 84, 66, 0, 14, 73, 3),
        ("Wind edge 20",                date(7,21), 84, 66, 0, 20, 73, 2),
        ("Wind edge 28",                date(7,21), 84, 66, 0, 28, 73, 0),

        // MARK: - Edge Cases: same setup, changing precipitation
        ("Rain edge 0",                 date(8,8),  83, 65, 0, 9, 73, 4),
        ("Rain edge 2",                 date(8,8),  83, 65, 2, 9, 73, 3),
        ("Rain edge 5",                 date(8,8),  83, 65, 5, 9, 73, 2),
        ("Rain edge 10",                date(8,8),  83, 65, 10, 9, 73, 0),

        // MARK: - Seasonal fakeouts
        ("Hot April fakeout",           date(4,27), 78, 56, 0, 10, 42, 0),
        ("Warm May fakeout",            date(5,5),  79, 58, 0, 9, 45, 1),
        ("Nice October fakeout",        date(10,1), 76, 58, 0, 10, 54, 2),
        ("Cold water June fakeout 2",   date(6,1),  84, 64, 0, 8, 47, 1),
        ("September warmth fading",     date(9,29), 77, 59, 0, 10, 58, 2),
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
