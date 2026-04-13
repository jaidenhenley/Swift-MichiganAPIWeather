//
//  MichiganAPIWeatherTests.swift
//  MichiganAPIWeatherTests
//
//  Created by Jaiden Henley on 4/8/26.
//

// Temporarily disabled — CoreML model deallocation causes malloc crash
// that kills the entire test process, including unrelated tests.
#if false
import XCTest
import CoreML
@testable import MichiganAPIWeather

final class BeachCrowdClassifierTests: XCTestCase {

    // Shared instance that lives for the entire test process to avoid
    // a CoreML deallocation bug that corrupts the heap.
    nonisolated(unsafe) private static var _sharedModel: BeachCrowdClassifier?
    nonisolated(unsafe) private static var _modelLoaded = false

    var model: BeachCrowdClassifier!

    override func setUpWithError() throws {
        if !Self._modelLoaded {
            Self._sharedModel = try? BeachCrowdClassifier(configuration: MLModelConfiguration())
            Self._modelLoaded = true
        }
        model = Self._sharedModel
        try XCTSkipIf(model == nil, "CoreML model failed to load")
    }

    // MARK: - Helpers

    func predict(
        month_sin: Double,
        month_cos: Double,
        day_of_week: Double,
        is_weekend: Double,
        is_holiday: Double,
        temp_max: Double,
        temp_min: Double,
        temp_range: Double,
        precipitation: Double,
        wind_max: Double,
        water_temp_f: Double,
        is_peak_summer: Double
    ) throws -> Int64 {
        let input = BeachCrowdClassifierInput(
            month_sin: month_sin,
            month_cos: month_cos,
            day_of_week: day_of_week,
            is_weekend: is_weekend,
            is_holiday: is_holiday,
            temp_max: temp_max,
            temp_min: temp_min,
            temp_range: temp_range,
            precipitation: precipitation,
            wind_max: wind_max,
            water_temp_f: water_temp_f,
            is_peak_summer: is_peak_summer
        )
        return try model.prediction(input: input).crowdLevel
    }

    // MARK: - Sanity Tests

    func testModelLoads() {
        XCTAssertNotNil(model)
    }

    func testOutputIsValidClass() throws {
        let result = try predict(
            month_sin: 1.0, month_cos: 0.0,
            day_of_week: 6, is_weekend: 1,
            is_holiday: 0,
            temp_max: 88, temp_min: 72, temp_range: 16,
            precipitation: 0, wind_max: 8,
            water_temp_f: 74, is_peak_summer: 1
        )
        XCTAssertTrue([0, 1, 2].contains(result), "crowdLevel must be 0, 1, or 2")
    }

    // MARK: - Scenario Tests

    func testPeakSummerWeekendShouldBeHighCrowd() throws {
        // Hot summer Saturday, no rain, warm water — expect 2 (high)
        let result = try predict(
            month_sin: 1.0, month_cos: 0.0,
            day_of_week: 6, is_weekend: 1,
            is_holiday: 0,
            temp_max: 92, temp_min: 75, temp_range: 17,
            precipitation: 0, wind_max: 5,
            water_temp_f: 76, is_peak_summer: 1
        )
        XCTAssertEqual(result, 2, "Hot summer weekend should predict high crowd")
    }

    func testColdWinterWeekdayShouldBeLowCrowd() throws {
        // January weekday, cold, off-season — expect 0 (low)
        let result = try predict(
            month_sin: -1.0, month_cos: 0.0,
            day_of_week: 2, is_weekend: 0,
            is_holiday: 0,
            temp_max: 32, temp_min: 20, temp_range: 12,
            precipitation: 0.4, wind_max: 25,
            water_temp_f: 38, is_peak_summer: 0
        )
        XCTAssertEqual(result, 0, "Cold winter weekday should predict low crowd")
    }

    func testHeavyRainShouldReduceCrowd() throws {
        // Summer day but heavy rain — expect 0 or 1
        let result = try predict(
            month_sin: 0.9, month_cos: 0.4,
            day_of_week: 6, is_weekend: 1,
            is_holiday: 0,
            temp_max: 78, temp_min: 65, temp_range: 13,
            precipitation: 1.5, wind_max: 30,
            water_temp_f: 70, is_peak_summer: 1
        )
        XCTAssertLessThan(result, 2, "Heavy rain should not predict high crowd")
    }

    func testHolidayWeekendShouldBeHighCrowd() throws {
        // 4th of July weekend — expect 2
        let result = try predict(
            month_sin: 0.97, month_cos: -0.26,
            day_of_week: 6, is_weekend: 1,
            is_holiday: 1,
            temp_max: 88, temp_min: 70, temp_range: 18,
            precipitation: 0, wind_max: 7,
            water_temp_f: 73, is_peak_summer: 1
        )
        XCTAssertEqual(result, 2, "Holiday weekend should predict high crowd")
    }

    // MARK: - Probability Tests

    func testClassProbabilitiesSumToOne() throws {
        let input = BeachCrowdClassifierInput(
            month_sin: 1.0, month_cos: 0.0,
            day_of_week: 6, is_weekend: 1,
            is_holiday: 0,
            temp_max: 88, temp_min: 72, temp_range: 16,
            precipitation: 0, wind_max: 8,
            water_temp_f: 74, is_peak_summer: 1
        )
        let output = try model.prediction(input: input)
        let total = output.classProbability.values.reduce(0, +)
        XCTAssertEqual(total, 1.0, accuracy: 0.01, "Class probabilities must sum to 1")
    }

    func testHighConfidenceOnClearSummerDay() throws {
        let input = BeachCrowdClassifierInput(
            month_sin: 1.0, month_cos: 0.0,
            day_of_week: 6, is_weekend: 1,
            is_holiday: 0,
            temp_max: 95, temp_min: 78, temp_range: 17,
            precipitation: 0, wind_max: 4,
            water_temp_f: 78, is_peak_summer: 1
        )
        let output = try model.prediction(input: input)
        let confidence = output.classProbability[2] ?? 0
        XCTAssertGreaterThan(confidence, 0.5, "Should be confident about high crowd on ideal beach day")
    }
}
#endif
