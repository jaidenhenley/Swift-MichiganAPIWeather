//
//  MapViewCard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/17/26.
//

import SwiftUI

import SwiftUI

struct MapViewCard: View {
    let beach: Beach
    let isSelected: Bool
    var body: some View {
        HStack(spacing: 0) {
            Image(beach.images.first ?? .grandHaven1)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 118)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 14, bottomTrailingRadius: 0, topTrailingRadius: 0))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(beach.beachName)
                    .foregroundStyle(.primary)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                HStack(spacing: 4) {
                    if let icon = beach.displayKeywords.first?.icon {
                        Image(systemName: icon)
                            .font(.caption2)
                            .foregroundStyle(.blueGreen)
                    }
                    Text(beach.displayKeywords.first?.label ?? "")
                        .foregroundStyle(.blueGreen)
                        .font(.caption2)
                }
            }
            .padding(10)
            .frame(width: 108, height: 118)
        }
        .frame(width: 208, height: 118)
        .background(Color(.customWhite))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}



