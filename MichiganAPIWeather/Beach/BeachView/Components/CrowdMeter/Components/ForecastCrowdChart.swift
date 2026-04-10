//
//  ForecastCrowdChart.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct ForecastCrowdChart: View {
    let forecastCrowd: [CrowdLevel]
    let forecastDays: [ForecastDay]
    
    var body: some View {
        VStack {
            Text("\(Image(systemName: "person.3.fill")) CROWD FORECAST")
                .font(.footnote)
                .bold()
                .foregroundColor(.beachViewText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(forecastCrowd.prefix(7).enumerated()), id: \.offset) { i, level in
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(level.color)
                            .frame(width: 35, height: barHeight(for: level))
                        Text(forecastDays[safe: i]?.name.prefix(3).uppercased() ?? "")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    func barHeight(for level: CrowdLevel) -> CGFloat {
       switch level {
       case .low:    return 40
       case .medium: return 70
       case .high:   return 100
       }
   }

}

