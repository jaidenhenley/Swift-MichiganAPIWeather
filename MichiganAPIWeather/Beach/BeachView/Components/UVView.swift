//
//  UVView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct UVView: View {
    @Environment(BeachViewModel.self) var viewModel

    var uvValue: Int { viewModel.uvIndex }
    
    var uvCategory: String {
        switch uvValue {
        case 0...2: return "Low"
        case 3...5: return "Moderate"
        case 6...7: return "High"
        case 8...10: return "Very High"
        default: return "Extreme"
        }
    }
    
    var uvColor: Color {
        switch uvValue {
        case 0...2: return .green
        case 3...5: return .yellow
        case 6...7: return .orange
        case 8...10: return .red
        default: return .purple
        }
    }
    
    var uvAdvice: String {
        switch uvValue {
        case 0...2: return "No protection needed."
        case 3...5: return "Protection recommended. Wear sunscreen."
        case 6...7: return "High risk. Reduce time in the sun."
        case 8...10: return "Very high risk. Extra protection required."
        default: return "Extreme risk. Avoid sun exposure."
        }
    }
    
    var body: some View {
        ZStack {
            Color.beachHeaderBox.cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 8) {
                // Header
                Label("UV INDEX", systemImage: "sun.max.fill")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                // Index number and category
                Text("\(uvValue)")
                    .font(.system(size: 36, weight: .medium))
                
                Text(uvCategory)
                    .font(.title3)
                    .fontWeight(.medium)
                
                Spacer()
                
                SegmentedProgressBar(uvIndex: uvValue)
                
                Text(uvAdvice)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.beachViewText, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    func dotOffset(in width: CGFloat) -> CGFloat {
        let clamped = min(max(Double(uvValue), 0), 11)
        return (clamped / 11) * (width - 14)
    }
    
}

struct UVIndexBar: View {
    let uvIndex: Int
    let uvColor: Color

    let segments = 10
    

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<segments, id: \.self) { i in
                Capsule()
                    .fill(i <= uvIndex  - 1 ? uvColor : Color.gray.opacity(0.3))
                    .frame(height: 12)
            }
        }
    }
}


struct SegmentedProgressBar: View {
    let uvIndex: Int
    let color: Color = .green
    
    let totalSegments = 10

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSegments, id: \.self) { index in
                shape(for: index)
                    .fill(index < uvIndex ? color.opacity(opacity(for: index)) : Color.gray.opacity(0.3))
                    .frame(height: 15)
            }
        }
    }

    func cornerRadius(for index: Int) -> CGFloat {
        let isFirst = index == 0
        let isLast = index == totalSegments - 1
        return (isFirst || isLast) ? 14 : 2
    }

    func opacity(for index: Int) -> Double {
        // Fade effect near the cutoff
        let distance = uvIndex - 1 - index
        return distance == 0 ? 0.5 : 1.0
    }
    
    func shape(for index: Int) -> AnyShape {
        let r: CGFloat = 14
        let isFirst = index == 0
        let isLast = index == totalSegments - 1

        if isFirst {
            return AnyShape(UnevenRoundedRectangle(
                topLeadingRadius: r, bottomLeadingRadius: r,
                bottomTrailingRadius: 0, topTrailingRadius: 0
            ))
        } else if isLast {
            return AnyShape(UnevenRoundedRectangle(
                topLeadingRadius: 0, bottomLeadingRadius: 0,
                bottomTrailingRadius: r, topTrailingRadius: r
            ))
        } else {
            return AnyShape(Rectangle())
        }
    }
}
#Preview {
    UVView()
}
