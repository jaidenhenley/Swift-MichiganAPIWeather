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
            VStack {
                Label("UV INDEX", systemImage: "sun.max.fill")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.beachViewText)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Header
                    
                    
                    // Index number and category
                    Text("\(uvValue)")
                        .font(.system(size: 60, weight: .bold))
                    
                    Text(uvCategory)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    SegmentedProgressBar(uvIndex: uvValue, color: uvColor)
                        .accessibilityHidden(true)
                    
                    Text(uvAdvice)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 4)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.beachViewText, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("UV Index, \(uvValue), \(uvCategory). \(uvAdvice)")
    }
    
    func dotOffset(in width: CGFloat) -> CGFloat {
        let clamped = min(max(Double(uvValue), 0), 11)
        return (clamped / 11) * (width - 14)
    }
    
}
