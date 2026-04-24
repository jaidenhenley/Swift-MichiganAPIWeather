//
//  NearBeachesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import CoreLocation
import Combine
import SwiftUI

struct NearBeachRow: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    let images: [ImageResource]
    let beach: Beach
    let beachName: String
    let beachID: Int

    @State private var currentImageIndex = 0
    
    let timer = Timer.publish(every: 180.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                BeachView(beach: beach, beachID: beach.id)
            } label: {
                ZStack(alignment: .topTrailing) {
                    if !images.isEmpty {
                        Image(images[currentImageIndex])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 95, height: 132)
                            .clipped()
                            .cornerRadius(12)
                            .id("\(beach.id)-\(currentImageIndex)")
                            .transition(.opacity)
                        
                    }
                }
            }
            .buttonStyle(.plain)
            
            Text(beachName)
                .font(.footnote)
                .frame(height: 40, alignment: .topLeading)

                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 80, alignment: .leading)
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
