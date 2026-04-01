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
    
    func predict(for date: Date) -> CrowdLevel {
        let cal = Calendar.current
        let month = cal.component(.month, from: date)
        let dow = cal.component(.weekday, from: date)
        let isWeekend = dow == 0 || dow == 6
        let season = seasonForm(month: month)
        
        guard let input = try? MLMultiArray(shape: [1,5], dataType: .float32) else {
            return .medium
        }
        
        input[0] = NSNumber(value: Float(month))
        input[1] = NSNumber(value: Float(dow))
        input[2] = NSNumber(value: Float(isWeekend ? 1 : 0))
        input[3] = NSNumber(value: 0) // is_holiday — wire up later
        input[4] = NSNumber(value: Float(season))
        
        guard let provider = try? MLDictionaryFeatureProvider(dictionary: ["input": input]) else {
            return .medium
        }
        guard let coreModel = model?.model,
              let result = try? coreModel.prediction(from: provider) else {
            return .medium
        }
        
        if let label = result.featureValue(for: "var_82")?.multiArrayValue {
            return CrowdLevel(rawValue: Int(label[0].intValue)) ?? .medium
        }
        return .medium
    }
    private func seasonForm(month: Int) -> Int {
        switch month {
        case 12, 1, 2: return 0
        case 3, 4, 5: return 1
        case 6, 7, 8: return 2
        default: return 3
        }
    }
}

func testCrowdModel() {
    guard let model = try? BeachCrowdClassifier(configuration: MLModelConfiguration()),
          let input = try? MLMultiArray(shape: [1, 5], dataType: .float32) else {
        print("Model failed to load")
        return
    }

    // Simulate: July, Saturday, weekend, not holiday, summer
    input[0] = 7   // month
    input[1] = 6   // day_of_week (Saturday)
    input[2] = 1   // is_weekend
    input[3] = 0   // is_holiday
    input[4] = 2   // season (summer)

    guard let provider = try? MLDictionaryFeatureProvider(dictionary: ["input": input]),
          let result = try? model.model.prediction(from: provider),
          let label = result.featureValue(for: "var_82")?.multiArrayValue else {
        print("Prediction failed")
        return
    }

    let crowdLevel = label[0].intValue // 0=Low, 1=Medium, 2=High
    print("July Saturday prediction: \(crowdLevel)") // Should be 2 (High)

    // Test a low scenario: November, Tuesday, not weekend
    input[0] = 11
    input[1] = 2
    input[2] = 0
    input[3] = 0
    input[4] = 3

    let provider2 = try? MLDictionaryFeatureProvider(dictionary: ["input": input])
    let result2 = try? model.model.prediction(from: provider2!)
    let label2 = result2?.featureValue(for: "var_82")?.multiArrayValue
    print("November Tuesday prediction: \(label2?[0].intValue ?? -1)") // Should be 0 (Low)
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
