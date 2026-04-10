//
//  MapPreviewCard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import SwiftUI

struct BeachPreviewCard: View {
    let beach: BeachViewModel.ViewBeach
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(beach.beachImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(beach.beachName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(beach.shortDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
        .padding(.bottom, 8)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
    }
}



