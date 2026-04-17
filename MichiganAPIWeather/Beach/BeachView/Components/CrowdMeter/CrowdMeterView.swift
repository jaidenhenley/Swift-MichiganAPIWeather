

import SwiftUI

struct CrowdMeterView: View {
    let forecastCrowd: [CrowdLevel]
    let forecastDays: [ForecastDay]

    var body: some View {
        VStack(spacing: 10) {
            
            
            CurrentCrowdBar(crowdLevel: forecastCrowd.first ?? .medium)
            
            ForecastCrowdChart(forecastCrowd: forecastCrowd, forecastDays: forecastDays)
            
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.secondary)
        )
        .padding(.horizontal)
    }

     func barHeight(for level: CrowdLevel) -> CGFloat {
        switch level {
        case .low:    return 40
        case .medium: return 70
        case .high:   return 100
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
