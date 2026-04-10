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
                    RoundedRectangle(cornerRadius: 20)
                        .fill(index <= crowdLevel.rawValue ? crowdLevel.currentColor : Color.gray.opacity(0.3))
                        .frame(height: 16)
                }
            }
        }
    }
}

#Preview {
    CurrentCrowdBar(crowdLevel: .medium)
}
