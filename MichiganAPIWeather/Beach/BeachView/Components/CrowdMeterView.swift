

import SwiftUI

struct CrowdMeterView: View {
    let forecastCrowd: [CrowdLevel]
    let forecastDays: [ForecastDay]

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Current Crowd Prediction")
                
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(forecastCrowd.first?.color ?? .blue)
                Text(forecastCrowd.first?.label ?? "N/A")
            }
            
            HStack {
                Image(systemName: "person.3.fill")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
                Text("CROWD FORECAST")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 40)

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

            HStack {
                Text("Low")
                    .foregroundColor(.green)
                Spacer()
                Text("Moderate")
                    .foregroundColor(.orange)
                Spacer()
                Text("Busy")
                    .foregroundColor(.red)
            }
            .font(.caption)
            .padding(.horizontal, 40)
        }
    }

    private func barHeight(for level: CrowdLevel) -> CGFloat {
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
