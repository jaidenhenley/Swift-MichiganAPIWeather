//
//  MightLikeScrollView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import SwiftUI

struct MightLikeScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<3) { _ in
                    NavigationLink {
                        BeachView(beach: Beach.allBeaches[1], beachID: 2) // destination
                    } label: {
                        VStack(spacing: 0) {
                            ZStack(alignment: .topTrailing) {
                                Image(.grandHaven)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 332, height: 253 * 0.7)
                                    .clipped()
                                HeartView()
                                    .padding()
                            }
                            
                            ZStack {
                                Color.lightBlue
                                
                                VStack(alignment: .leading) {
                                    Text("Grand Haven")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text("Lake Michigan")
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
    MightLikeScrollView()
}
