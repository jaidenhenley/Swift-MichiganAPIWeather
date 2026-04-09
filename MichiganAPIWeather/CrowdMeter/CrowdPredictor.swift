//
//  CrowdPredictor.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/1/26.
//

import CoreML
import SwiftUI

class CrowdPredictor {
    private let model = try? BeachCrowdClassifier(configuration: MLModelConfiguration())
        
    
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
        case .low:      return "Not Busy"
        case .medium:   return "Moderate"
        case .high:     return "Busy"
        }
    }

    var color: Color {
        switch self {
        case .low:      return .green
        case .medium:   return .yellow
        case .high:     return .orange
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
    let labels = ["Low", "Medium", "High"]
    var passed = 0
    
    func date_from(_ str: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: str) ?? Date()
    }
    
    // Fields: name, date, tempMax, tempMin, precipitation, windMax, waterTemp, expectedClass
    let tests: [(String, Date, Double, Double, Double, Double, Double?, Int)] = [

        // Very Low
        ("2001-04-26 Very Low", date_from("2001-04-26"), 47.6, 41.5, 4.6,  37.5, 41.2, 0),
        ("2016-05-04 Very Low", date_from("2016-05-04"), 41.3, 38.3, 4.3,  35.1, 44.1, 0),
        ("2006-05-11 Very Low", date_from("2006-05-11"), 50.1, 44.7, 39.1, 40.2, 48.8, 0),
        ("2017-04-15 Very Low", date_from("2017-04-15"), 65.2, 48.7, 23.0, 31.3, 41.9, 0),
        ("1983-10-20 Very Low", date_from("1983-10-20"), 50.1, 41.8, 0.0,  25.0, 57.4, 0),
        ("2025-04-25 Very Low", date_from("2025-04-25"), 48.2, 38.0, 1.1,  27.3, 41.2, 0),
        ("1986-05-20 Very Low", date_from("1986-05-20"), 46.4, 43.6, 0.3,  23.4, 48.8, 0),
        ("2020-04-19 Very Low", date_from("2020-04-19"), 40.1, 30.7, 3.1,  25.1, 41.2, 0),
        ("2014-04-22 Very Low", date_from("2014-04-22"), 36.5, 30.8, 0.0,  31.1, 41.2, 0),
        ("2020-04-04 Very Low", date_from("2020-04-04"), 41.5, 30.7, 2.8,  23.1, 41.2, 0),
        ("1982-04-24 Very Low", date_from("1982-04-24"), 45.9, 38.9, 0.0,  29.9, 41.2, 0),
        ("2023-05-05 Very Low", date_from("2023-05-05"), 58.6, 43.2, 14.4, 27.0, 48.8, 0),
        ("1980-10-19 Very Low", date_from("1980-10-19"), 45.4, 41.7, 5.2,  26.8, 57.4, 0),
        ("2021-04-27 Very Low", date_from("2021-04-27"), 57.5, 39.3, 3.9,  28.0, 41.2, 0),
        ("1990-05-29 Very Low", date_from("1990-05-29"), 50.1, 47.0, 0.0,  26.2, 48.8, 0),
        ("1982-05-16 Very Low", date_from("1982-05-16"), 52.0, 47.5, 5.0,  15.8, 48.8, 0),
        ("2016-04-25 Very Low", date_from("2016-04-25"), 46.0, 38.4, 14.1, 25.7, 41.2, 0),
        ("1999-05-21 Very Low", date_from("1999-05-21"), 57.3, 48.8, 5.4,  30.1, 48.8, 0),
        ("1983-10-08 Very Low", date_from("1983-10-08"), 55.5, 49.5, 2.5,  29.7, 57.4, 0),
        ("2014-05-03 Very Low", date_from("2014-05-03"), 42.0, 35.9, 3.2,  25.4, 48.8, 0),
        ("1994-04-08 Very Low", date_from("1994-04-08"), 37.8, 24.4, 0.8,  23.1, 41.2, 0),
        ("2013-04-17 Very Low", date_from("2013-04-17"), 36.3, 25.4, 3.4,  22.9, 41.2, 0),
        ("1998-04-09 Very Low", date_from("1998-04-09"), 41.7, 35.7, 0.0,  33.8, 41.2, 0),
        ("2008-10-29 Very Low", date_from("2008-10-29"), 42.5, 37.7, 1.2,  32.2, 57.4, 0),
        ("1983-04-14 Very Low", date_from("1983-04-14"), 47.0, 35.8, 19.4, 43.6, 41.2, 0),
        ("2010-04-27 Very Low", date_from("2010-04-27"), 42.2, 37.1, 0.0,  29.3, 41.2, 0),
        ("1981-05-26 Very Low", date_from("1981-05-26"), 51.4, 48.1, 0.0,  14.6, 48.8, 0),
        ("2013-04-22 Very Low", date_from("2013-04-22"), 38.4, 33.2, 0.2,  28.1, 41.2, 0),
        ("1986-10-29 Very Low", date_from("1986-10-29"), 56.1, 45.0, 0.4,  26.9, 57.4, 0),
        ("2012-04-10 Very Low", date_from("2012-04-10"), 37.7, 34.3, 0.0,  31.1, 41.2, 0),

        // Low
        ("1990-04-09 Low", date_from("1990-04-09"), 41.3, 33.9, 0.2,  28.2, 41.2, 0),
        ("2002-10-16 Low", date_from("2002-10-16"), 42.5, 41.0, 0.5,  23.9, 57.4, 0),
        ("1989-09-26 Low", date_from("1989-09-26"), 53.1, 49.2, 0.0,  30.4, 66.1, 0),
        ("1986-06-20 Low", date_from("1986-06-20"), 62.8, 55.5, 0.0,  22.7, 58.0, 0),
        ("2005-09-02 Low", date_from("2005-09-02"), 71.0, 64.7, 0.0,  29.8, 66.1, 0),
        ("1980-06-30 Low", date_from("1980-06-30"), 63.0, 56.9, 0.0,  25.2, 58.0, 0),
        ("2015-04-04 Low", date_from("2015-04-04"), 33.5, 19.6, 0.0,  23.6, 41.2, 0),
        ("2015-05-28 Low", date_from("2015-05-28"), 56.4, 45.7, 0.0,  19.3, 52.2, 0),
        ("1981-06-05 Low", date_from("1981-06-05"), 61.2, 51.3, 0.1,  27.5, 58.0, 0),
        ("1997-06-16 Low", date_from("1997-06-16"), 58.6, 51.3, 9.5,  38.0, 58.0, 0),
        ("1998-10-24 Low", date_from("1998-10-24"), 55.1, 51.7, 0.0,  28.5, 57.4, 0),
        ("2019-05-20 Low", date_from("2019-05-20"), 47.3, 37.9, 1.8,  25.3, 47.5, 0),
        ("1980-09-04 Low", date_from("1980-09-04"), 71.2, 68.1, 0.0,  32.9, 66.1, 0),
        ("1981-09-29 Low", date_from("1981-09-29"), 53.2, 47.5, 2.5,  17.6, 66.1, 0),
        ("1993-05-21 Low", date_from("1993-05-21"), 43.9, 40.4, 0.0,  13.4, 48.8, 0),
        ("2002-10-12 Low", date_from("2002-10-12"), 63.3, 51.0, 8.1,  30.0, 57.4, 0),
        ("1997-10-10 Low", date_from("1997-10-10"), 56.4, 51.6, 0.0,  29.9, 57.4, 0),
        ("1996-06-19 Low", date_from("1996-06-19"), 57.7, 55.3, 6.1,  20.2, 58.0, 0),
        ("1990-06-06 Low", date_from("1990-06-06"), 57.8, 51.6, 1.6,  29.0, 58.0, 0),
        ("2004-05-01 Low", date_from("2004-05-01"), 39.1, 37.3, 1.7,  20.6, 48.8, 0),
        ("2017-05-20 Low", date_from("2017-05-20"), 60.8, 42.3, 4.1,  28.4, 50.4, 0),
        ("2012-05-21 Low", date_from("2012-05-21"), 58.2, 48.6, 0.0,  27.7, 48.8, 0),
        ("1986-06-23 Low", date_from("1986-06-23"), 65.5, 59.7, 5.1,  24.4, 58.0, 0),
        ("2015-06-30 Low", date_from("2015-06-30"), 61.5, 51.3, 10.9, 22.5, 64.5, 0),
        ("2020-10-26 Low", date_from("2020-10-26"), 39.0, 35.7, 5.4,  22.6, 53.1, 0),
        ("2010-05-20 Low", date_from("2010-05-20"), 58.0, 51.9, 0.0,  11.1, 48.8, 0),
        ("1991-05-31 Low", date_from("1991-05-31"), 60.6, 55.8, 0.2,  14.0, 48.8, 0),
        ("1988-10-01 Low", date_from("1988-10-01"), 65.7, 59.1, 26.5, 23.9, 57.4, 0),
        ("2003-05-21 Low", date_from("2003-05-21"), 43.8, 39.3, 0.0,  19.3, 48.8, 0),
        ("1990-10-05 Low", date_from("1990-10-05"), 63.1, 54.0, 0.3,  30.3, 57.4, 0),

        // Medium
        ("1979-06-25 Medium", date_from("1979-06-25"), 59.9, 52.2, 0.0,  15.1, 58.0, 1),
        ("1987-09-27 Medium", date_from("1987-09-27"), 68.7, 62.2, 0.0,  24.1, 66.1, 1),
        ("1980-07-11 Medium", date_from("1980-07-11"), 71.4, 67.4, 0.0,  17.5, 66.6, 1),
        ("2013-06-05 Medium", date_from("2013-06-05"), 53.8, 49.3, 0.5,  15.9, 58.0, 1),
        ("1982-07-06 Medium", date_from("1982-07-06"), 71.8, 65.9, 0.0,  31.4, 66.6, 1),
        ("2024-09-13 Medium", date_from("2024-09-13"), 78.9, 60.9, 0.0,  16.6, 66.1, 1),
        ("2011-06-06 Medium", date_from("2011-06-06"), 64.9, 56.7, 8.4,  18.6, 58.0, 1),
        ("2004-07-22 Medium", date_from("2004-07-22"), 69.9, 61.8, 0.0,  25.8, 66.6, 1),
        ("1987-08-21 Medium", date_from("1987-08-21"), 76.9, 67.9, 9.9,  24.3, 69.5, 1),
        ("2021-08-06 Medium", date_from("2021-08-06"), 72.6, 65.7, 3.3,  24.9, 70.4, 1),
        ("1992-09-11 Medium", date_from("1992-09-11"), 60.0, 53.5, 0.0,  15.5, 66.1, 1),
        ("2016-10-23 Medium", date_from("2016-10-23"), 54.2, 49.1, 0.7,  25.9, 59.1, 1),
        ("1986-08-20 Medium", date_from("1986-08-20"), 72.2, 63.6, 0.0,  16.9, 69.5, 1),
        ("1985-08-01 Medium", date_from("1985-08-01"), 69.3, 64.6, 0.0,  21.6, 69.5, 1),
        ("2022-10-29 Medium", date_from("2022-10-29"), 55.7, 42.5, 0.0,  16.5, 57.4, 1),
        ("2024-10-21 Medium", date_from("2024-10-21"), 65.7, 58.2, 0.0,  27.2, 57.4, 1),
        ("2024-09-09 Medium", date_from("2024-09-09"), 65.9, 56.9, 0.1,  24.9, 66.1, 1),
        ("1996-09-05 Medium", date_from("1996-09-05"), 74.4, 67.3, 0.1,  12.9, 66.1, 1),
        ("2022-07-13 Medium", date_from("2022-07-13"), 65.8, 58.0, 12.8, 13.8, 66.6, 1),
        ("1992-07-08 Medium", date_from("1992-07-08"), 66.9, 63.6, 13.0, 18.2, 66.6, 1),
        ("2024-07-23 Medium", date_from("2024-07-23"), 70.9, 62.9, 12.2, 21.7, 66.6, 1),
        ("1992-08-08 Medium", date_from("1992-08-08"), 69.9, 66.3, 30.2, 24.7, 69.5, 1),
        ("1991-06-11 Medium", date_from("1991-06-11"), 65.8, 58.8, 0.2,  15.5, 58.0, 1),
        ("2001-09-22 Medium", date_from("2001-09-22"), 64.5, 61.1, 0.1,  14.0, 66.1, 1),
        ("1987-06-24 Medium", date_from("1987-06-24"), 72.4, 68.1, 0.0,  16.8, 58.0, 1),
        ("1988-08-24 Medium", date_from("1988-08-24"), 68.9, 66.5, 2.7,  28.7, 69.5, 1),
        ("2013-06-12 Medium", date_from("2013-06-12"), 57.4, 51.7, 0.0,  17.0, 56.4, 1),
        ("2002-07-29 Medium", date_from("2002-07-29"), 75.3, 70.4, 9.2,  25.3, 66.6, 1),
        ("1981-08-04 Medium", date_from("1981-08-04"), 72.9, 69.4, 11.2, 20.2, 69.5, 1),
        ("1993-07-29 Medium", date_from("1993-07-29"), 69.0, 63.5, 0.5,  30.8, 66.6, 1),

        // High
        ("1983-07-09 High", date_from("1983-07-09"), 70.2, 66.1, 0.0,  20.9, 66.6, 2),
        ("2002-08-04 High", date_from("2002-08-04"), 74.9, 72.2, 12.5, 22.0, 69.5, 2),
        ("2020-06-20 High", date_from("2020-06-20"), 78.9, 62.9, 0.2,  13.9, 58.0, 2),
        ("2025-08-22 High", date_from("2025-08-22"), 72.1, 61.6, 0.0,  23.8, 59.4, 2),
        ("1991-07-09 High", date_from("1991-07-09"), 68.2, 63.4, 0.0,  14.7, 66.6, 2),
        ("2012-07-07 High", date_from("2012-07-07"), 80.7, 70.0, 0.0,  26.4, 66.6, 2),
        ("2000-07-26 High", date_from("2000-07-26"), 73.6, 66.1, 0.0,  19.2, 66.6, 2),
        ("1997-06-22 High", date_from("1997-06-22"), 63.4, 56.4, 0.0,  12.1, 58.0, 2),
        ("2023-08-18 High", date_from("2023-08-18"), 68.0, 59.5, 0.0,  25.3, 64.9, 2),
        ("1991-07-20 High", date_from("1991-07-20"), 76.9, 71.2, 4.9,  13.3, 66.6, 2),
        ("1993-07-11 High", date_from("1993-07-11"), 70.4, 66.0, 6.2,  20.1, 66.6, 2),
        ("2010-07-23 High", date_from("2010-07-23"), 75.2, 68.1, 0.6,  19.7, 66.6, 2),
        ("1992-07-26 High", date_from("1992-07-26"), 70.8, 65.7, 1.0,  22.2, 66.6, 2),
        ("2016-07-19 High", date_from("2016-07-19"), 70.8, 64.7, 0.0,  15.6, 71.1, 2),
        ("1994-07-28 High", date_from("1994-07-28"), 67.2, 63.0, 0.2,  11.6, 66.6, 2),
        ("1989-08-17 High", date_from("1989-08-17"), 67.2, 62.7, 0.0,  14.8, 69.5, 2),
        ("2025-08-07 High", date_from("2025-08-07"), 78.1, 65.9, 0.0,  19.8, 67.0, 2),
        ("1985-07-26 High", date_from("1985-07-26"), 69.9, 63.2, 0.0,  15.9, 66.6, 2),
        ("1980-07-06 High", date_from("1980-07-06"), 64.4, 57.3, 0.0,  16.9, 66.6, 2),
        ("2020-08-06 High", date_from("2020-08-06"), 72.5, 62.9, 0.0,  16.9, 53.3, 2),
        ("2020-07-19 High", date_from("2020-07-19"), 77.1, 69.4, 8.9,  29.2, 66.6, 2),
        ("1979-08-11 High", date_from("1979-08-11"), 63.3, 60.4, 0.0,  24.1, 69.5, 2),
        ("2019-06-08 High", date_from("2019-06-08"), 74.0, 57.2, 0.0,  16.6, 55.1, 2),
        ("1995-07-03 High", date_from("1995-07-03"), 67.3, 60.3, 0.0,  28.2, 66.6, 2),
        ("2022-08-12 High", date_from("2022-08-12"), 68.5, 56.8, 0.0,  15.0, 69.5, 2),
        ("1992-08-05 High", date_from("1992-08-05"), 67.8, 60.8, 0.0,  14.7, 69.5, 2),
        ("1986-07-26 High", date_from("1986-07-26"), 71.2, 66.0, 0.0,  20.1, 66.6, 2),
        ("2019-07-31 High", date_from("2019-07-31"), 67.6, 58.2, 0.0,  12.9, 68.8, 2),
        ("1997-08-19 High", date_from("1997-08-19"), 68.4, 61.1, 0.0,  13.8, 69.5, 2),
        ("1994-08-17 High", date_from("1994-08-17"), 71.7, 65.5, 0.0,  15.8, 69.5, 2),

        // Very High
        ("2012-07-14 Very High", date_from("2012-07-14"), 80.0, 76.2, 0.5, 18.8, 66.6, 2),
        ("1999-07-05 Very High", date_from("1999-07-05"), 73.3, 69.0, 0.1, 29.8, 66.6, 2),
        ("2010-07-25 Very High", date_from("2010-07-25"), 72.9, 65.8, 0.0, 16.2, 66.6, 2),
        ("2011-08-29 Very High", date_from("2011-08-29"), 71.6, 67.7, 0.0, 22.9, 69.5, 2),
        ("1998-08-03 Very High", date_from("1998-08-03"), 78.3, 71.5, 0.2, 13.6, 69.5, 2),
        ("1993-08-14 Very High", date_from("1993-08-14"), 72.6, 70.0, 0.0, 14.4, 69.5, 2),
        ("2012-08-12 Very High", date_from("2012-08-12"), 71.5, 64.2, 0.0, 18.0, 46.7, 2),
        ("2024-08-04 Very High", date_from("2024-08-04"), 74.7, 68.5, 0.0, 11.6, 69.5, 2),
        ("2020-07-04 Very High", date_from("2020-07-04"), 76.6, 66.4, 0.0, 15.6, 66.6, 2),
        ("1987-08-24 Very High", date_from("1987-08-24"), 66.3, 60.0, 0.0, 19.8, 69.5, 2),
        ("1990-07-02 Very High", date_from("1990-07-02"), 67.3, 61.1, 0.0, 17.3, 66.6, 2),
        ("2003-08-10 Very High", date_from("2003-08-10"), 74.6, 69.4, 0.0, 16.1, 69.5, 2),
        ("2018-08-04 Very High", date_from("2018-08-04"), 81.8, 62.7, 0.0, 22.7, 74.4, 2),
        ("2018-07-16 Very High", date_from("2018-07-16"), 76.5, 67.9, 0.4, 20.0, 74.0, 2),
        ("2021-07-05 Very High", date_from("2021-07-05"), 80.0, 66.4, 1.7, 26.9, 59.0, 2),
        ("2022-07-10 Very High", date_from("2022-07-10"), 72.9, 59.5, 0.0, 25.8, 66.6, 2),
        ("2006-07-03 Very High", date_from("2006-07-03"), 73.6, 65.9, 0.3, 22.3, 66.6, 2),
        ("2024-08-25 Very High", date_from("2024-08-25"), 82.0, 62.2, 0.0, 11.2, 69.5, 2),
        ("2011-07-16 Very High", date_from("2011-07-16"), 74.1, 69.1, 0.0, 18.9, 66.6, 2),
        ("2003-07-05 Very High", date_from("2003-07-05"), 69.7, 65.6, 0.0, 13.5, 66.6, 2),
        ("2011-07-09 Very High", date_from("2011-07-09"), 72.5, 64.2, 0.0, 17.8, 66.6, 2),
        ("1989-07-08 Very High", date_from("1989-07-08"), 69.5, 62.1, 0.0, 15.5, 66.6, 2),
        ("1990-08-11 Very High", date_from("1990-08-11"), 69.0, 64.9, 0.0, 11.9, 69.5, 2),
        ("2011-08-22 Very High", date_from("2011-08-22"), 70.5, 64.9, 0.0, 18.4, 69.5, 2),
        ("2017-07-17 Very High", date_from("2017-07-17"), 68.7, 55.9, 0.0, 12.4, 59.4, 2),
        ("1995-07-15 Very High", date_from("1995-07-15"), 73.8, 67.8, 0.1, 14.8, 66.6, 2),
        ("1996-08-17 Very High", date_from("1996-08-17"), 71.1, 65.2, 0.0, 11.6, 69.5, 2),
        ("1997-07-07 Very High", date_from("1997-07-07"), 62.5, 56.7, 0.0, 15.1, 66.6, 2),
        ("2021-07-18 Very High", date_from("2021-07-18"), 73.8, 58.7, 0.0, 9.9,  69.4, 2),
        ("2018-08-19 Very High", date_from("2018-08-19"), 75.1, 62.3, 1.2, 15.3, 75.5, 2),
    ]
    let predictor = CrowdPredictor()
    for (name, testDate, tMax, tMin, precip, wind, water, expected) in tests {
        let result = predictor.predict(for: testDate, tempMax: tMax, tempMin: tMin,
                                       precipitation: precip, windMax: wind, waterTemp: water, isHoliday: false)
        let status = result.rawValue == expected ? "✅" : "❌"
        if result.rawValue == expected { passed += 1 }
        print("\(status) \(name): got \(labels[result.rawValue]), expected \(labels[expected])")
    }

    print("\n\(passed)/\(tests.count) tests passed")
}
