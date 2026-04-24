//
//  MightLikeScrollView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import SwiftUI
import Combine

struct MightLikeScrollView: View {
    let suggestions: [SuggestedBeach]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(suggestions, id: \.beach.id) { suggestion in
                    // We call the individual card here
                    MightLikeCard(suggestion: suggestion)
                }
            }
            .padding()
        }
    }
}

struct MightLikeCard: View {
    let suggestion: SuggestedBeach
    
    @State private var currentImageIndex = 0
    @Environment(\.colorScheme) var colorScheme
    let timer = Timer.publish(every: 180.0, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationLink {
            BeachView(beach: suggestion.beach, beachID: suggestion.beach.id)
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    if !suggestion.beach.images.isEmpty {
                        Image(suggestion.beach.images[currentImageIndex])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 332, height: 253 * 0.7)
                            .clipped()
                            .id("image_\(suggestion.beach.id)_\(currentImageIndex)")
                            .transition(.opacity)
                    }

                    FavoriteButtonView(beach: suggestion.beach)
                        .padding()
                }

                ZStack {
                    Color.youmightlikeoffwhite

                    VStack(alignment: .leading, spacing: 6) {
                        HStack() {
                            Text(suggestion.beach.beachName)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text(suggestion.beach.bodyOfWater)
                                .font(.subheadline)

                                .foregroundStyle(.blueGreen)
                            
                        }
                        Text(suggestion.reason)
                            .font(.caption2)
                            .foregroundStyle(.blueGreen)
                        HStack {
                            ForEach(suggestion.beach.displayKeywords.prefix(2), id: \.label) { keyword in
                                HStack(spacing: 4) {
                                    if let icon = keyword.icon {
                                        
                                        Image(systemName: icon)
                                            .font(.caption2)
                                            .foregroundStyle(.blueGreen)

                                    }
                                    Text(keyword.label)
                                        .font(.caption2)
                                        .foregroundStyle(.blueGreen)

                                }
                                .padding(.bottom, 8)
                            }
                        }
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 2)
                }
                .frame(width: 332, height: 253 * 0.3)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(
                color: colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.2),
                radius: 8
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.8), value: currentImageIndex)
        .onReceive(timer) { _ in
            if suggestion.beach.images.count > 1 {
                currentImageIndex = (currentImageIndex + 1) % suggestion.beach.images.count
                print("Image changed to index: \(currentImageIndex) for \(suggestion.beach.beachName)")
            }
        }
    }
}

#Preview {
    MightLikeScrollView(suggestions: [])
}
