//
//  MightLikeScrollView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import SwiftUI

struct MightLikeScrollView: View {
    let suggestions: [SuggestedBeach]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(suggestions, id: \.beach.id) { suggestion in
                    NavigationLink {
                        BeachView(beach: suggestion.beach, beachID: suggestion.beach.id)
                    } label: {
                        VStack(spacing: 0) {
                            ZStack(alignment: .topTrailing) {
                                Image(suggestion.beach.images.first ?? .grandHaven1)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 332, height: 253 * 0.7)
                                    .clipped()
                                FavoriteButtonView(beach: suggestion.beach)
                                    .padding()
                            }

                            ZStack {
                                Color.lightBlue

                                VStack(alignment: .leading) {
                                    Text(suggestion.beach.beachName)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(suggestion.reason)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                            }
                            .frame(width: 332, height: 253 * 0.3)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview {
    MightLikeScrollView(suggestions: [])
}
