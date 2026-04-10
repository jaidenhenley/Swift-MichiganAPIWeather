//
//  BeachRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct BeachRow: View {
    let beach: Beach
    
    var body: some View {
        HStack(spacing: 12) {
            Image(beach.image)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(beach.beachName)
                    .font(.subheadline)
                    .bold()
                Text(beach.shortDescription)
                    .font(.caption)
                    .foregroundStyle(.beachViewText)
                    .bold()
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 8) {
                    ForEach(beach.displayKeywords.prefix(4), id: \.self) { word in
                        ListTag(tagName: word)
                    }
                }            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.footnote)
        }
        .frame(width: 360, height: 130)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.white)
        )
        
    }
}

#Preview {
    BeachRow(beach: Beach.allBeaches[3])
        .background(
            Color.black
        )
}
