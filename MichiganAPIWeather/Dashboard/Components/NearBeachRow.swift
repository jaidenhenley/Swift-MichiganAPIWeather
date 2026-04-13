//
//  NearBeachesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct NearBeachRow: View {
    @Environment(BeachViewModel.self) var viewModel
    let images: [ImageResource]
    let beach: Beach
    let beachName: String
    let beachID: Int
    
    var body: some View {
        VStack {
            NavigationLink {
                BeachView(beach: beach, beachID: beach.id)
            } label: {
                ZStack(alignment: .topTrailing) {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 150)
                            .clipped()
                            .cornerRadius(12)
                    }
                    
                }
            }
            .overlay(alignment: .topTrailing) {
                FavoriteButtonView(beach: beach)
                    .padding(.top, 4)
            }
            Text(beachName)
                .font(.caption )
            
        }
    }
}

