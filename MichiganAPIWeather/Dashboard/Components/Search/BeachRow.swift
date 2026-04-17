//
//  BeachRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct BeachRow: View {
    let beach: Beach
    let isFavorited: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(beach.images[0])
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(beach.beachName)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if isFavorited {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }
                
                Text(beach.shortDescription)
                    .font(.footnote)
                    .foregroundStyle(.beachViewText)
                    .bold()
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 6) {
                    ForEach(beach.displayKeywords.prefix(4), id: \.label) { keyword in
                        ListTag(tagName: keyword.label, icon: keyword.icon)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
}

#Preview {
    BeachRow(beach: Beach.allBeaches[3], isFavorited: true)
        .background(
            Color.black
        )
}
