//
//  UVView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct UVView: View {
    @EnvironmentObject var viewModel: BeachViewModel
    
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
                
                // Gradient bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        LinearGradient(
                            colors: [.green, .yellow, .orange, .red, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(Capsule())
                        .frame(height: 6)
                        
                        // Indicator dot
                        Circle()
                            .fill(.white)
                            .frame(width: 14, height: 14)
                            .offset(x: dotOffset(in: geo.size.width))
                            .offset(y: -4)
                    }
                }
                .frame(height: 14)
                
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
#Preview {
    UVView()
}
