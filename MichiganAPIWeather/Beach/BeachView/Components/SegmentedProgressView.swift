//
//  SegmentedProgressView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/15/26.
//

import SwiftUI

struct SegmentedProgressBar: View {
    let uvIndex: Int
    let color: Color
    
    let totalSegments = 10

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(0..<totalSegments, id: \.self) { index in
                    shape(for: index)
                        .fill(index < uvIndex ? color.opacity(opacity(for: index)) : Color.gray.opacity(0.3))
                        .frame(height: 15)
                }
            }
            HStack {
                Text("0")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
                Spacer()
                
                Text(String(totalSegments))
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding(.horizontal, 4)
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
    SegmentedProgressBar(uvIndex: 2, color: .green)
}
