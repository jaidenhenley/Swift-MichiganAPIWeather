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
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            ZStack(alignment: .bottomLeading) {
                // Bars
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
                .frame(maxWidth: .infinity)
                .zIndex(1)
                
                // Grid lines positioned from the bottom of the bars
                // The day labels sit below the bars (~16pt: 4pt spacing + ~12pt text)
                gridLine(label: "Low")
                    .offset(y: -(dayLabelHeight + lowBarHeight))
                gridLine(label: "Mod")
                    .offset(y: -(dayLabelHeight + mediumBarHeight))
                gridLine(label: "Busy")
                    .offset(y: -(dayLabelHeight + maxBarHeight))
            }
            .frame(height: maxBarHeight + dayLabelHeight)
        }
        .padding(.vertical, 16)
    }
    
    private let lowBarHeight: CGFloat = 40
    private let mediumBarHeight: CGFloat = 70
    private let maxBarHeight: CGFloat = 100
    private let dayLabelHeight: CGFloat = 16
    
    func barHeight(for level: CrowdLevel) -> CGFloat {
        switch level {
        case .low:    return lowBarHeight
        case .medium: return mediumBarHeight
        case .high:   return maxBarHeight
        }
    }

}

// Helper for the grid lines
@ViewBuilder
func gridLine(label: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        Text(label)
            .font(.system(size: 8))
            .foregroundColor(.secondary)
        Divider()
            .background(Color.gray.opacity(0.3))
    }
}

