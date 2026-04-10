//
//  CrowdPredictor.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/1/26.
//

import CoreML
import SwiftUI

class CrowdPredictor {
    private let model: BeachCrowdClassifier?
        
    init() {
        if let m = try? BeachCrowdClassifier(configuration: MLModelConfiguration()) {
            model = m
            print("[Crowd Predictior] Model Loaded")
        } else {
            model = nil
            print("[CrowdPredictor] Model failed to load")
        }
    }
    
    func predict(for date: Date, tempMax: Double, tempMin: Double, precipitation: Double, windMax: Double, waterTemp: Double?, isHoliday: Bool) -> CrowdLevel {
        let cal = Calendar.current
        let month = cal.component(.month, from: date)
        let dow = cal.component(.weekday, from: date) - 1
        let isWeekend = dow == 0 || dow == 6
        let monthlyWaterTemp: [Int: Double] = [4:41,5:48,6:57,7:67,8:70,9:62,10:52,11:43]
        let resolvedWaterTemp = waterTemp ?? monthlyWaterTemp[month] ?? 55.0
        let tempRange = tempMax - tempMin
        let isPeakSummer = (month == 7 || month == 8) ? 1.0 : 0.0
        let monthSin = sin(2 * .pi * Double(month) / 12.0)
        let monthCos = cos(2 * .pi * Double(month) / 12.0)

        let featureDict: [String: Any] = [
            "month_sin":      monthSin,
            "month_cos":      monthCos,
            "day_of_week":    Double(dow),
            "is_weekend":     Double(isWeekend ? 1 : 0),
            "temp_max":       tempMax,
            "temp_min":       tempMin,
            "temp_range":     tempRange,
            "precipitation":  precipitation,
            "wind_max":       windMax,
            "water_temp_f":   resolvedWaterTemp,
            "is_peak_summer": isPeakSummer,
            "is_holiday": isHoliday ? 1.0 : 0.0
        ]

        guard let provider = try? MLDictionaryFeatureProvider(dictionary: featureDict),
              let result = try? model?.model.prediction(from: provider),
              let level = result.featureValue(for: "crowdLevel")?.int64Value else { return .medium }
        

        return CrowdLevel(rawValue: Int(level)) ?? .medium
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

enum CrowdLevel: Int {
    case low = 0, medium = 1, high = 2

    var label: String {
        switch self {
        case .low:      return "Not Busy"
        case .medium:   return "Moderate"
        case .high:     return "Busy"
        }
    }

    var color: Color {
        switch self {
        case .low:      return .crowdMeterBar.opacity(0.4)
        case .medium:   return .crowdMeterBar.opacity(0.7)
        case .high:     return .crowdMeterBar
        }
    }
    
    var currentColor: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}



