//
//  NearBeachesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI
import Combine

struct NearBeachRow: View {
    @Environment(BeachViewModel.self) var viewModel
    let images: [ImageResource]
    let beach: Beach
    let beachName: String
    let beachID: Int
    
    @State private var currentImageIndex = 0
    
    let timer = Timer.publish(every: 180.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            NavigationLink {
                BeachView(beach: beach, beachID: beach.id)
            } label: {
                ZStack(alignment: .topTrailing) {
                    if !images.isEmpty {
                        Image(images[currentImageIndex])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 150)
                            .clipped()
                            .cornerRadius(12)
                            .id("\(beach.id)-\(currentImageIndex)")
                            .transition(.opacity)
                    }
                }
            }
            .buttonStyle(.plain)
            .overlay(alignment: .topTrailing) {
                FavoriteButtonView(beach: beach)
                    .padding(.top, 4)
            }
            
            Text(beachName)
                .font(.caption)
                .lineLimit(1)
        }
        .onReceive(timer) { _ in
            if images.count > 1 {
                withAnimation(.easeInOut(duration: 0.8)) {
                    currentImageIndex = (currentImageIndex + 1) % images.count
                }
            }
        }
    }
}
