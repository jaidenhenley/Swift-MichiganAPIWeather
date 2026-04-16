//
//  CurrentCrowdBar.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct CurrentCrowdBar: View {
    let crowdLevel: CrowdLevel
    
    var body: some View {
        VStack {
            Text("\(Image(systemName: "clock.fill")) Now: \(crowdLevel.label)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    shape(for: index)
                        .fill(index <= crowdLevel.rawValue ? crowdLevel.currentColor : Color.gray.opacity(0.3))
                        .frame(height: 17)
                }
            }
        }
    }
    
    func shape(for index: Int) -> AnyShape {
        let r: CGFloat = 14
        let isFirst = index == 0
        let isLast = index == 2

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
    CurrentCrowdBar(crowdLevel: .medium)
}
