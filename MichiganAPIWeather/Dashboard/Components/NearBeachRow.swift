//
//  NearBeachesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct NearBeachRow: View {
    @Environment(BeachViewModel.self) var viewModel
    let image: ImageResource
    let beach: Beach
    let beachName: String
    let beachID: Int
    
    var body: some View {
        VStack {
            NavigationLink {
                BeachView(beach: beach, beachID: beach.id)
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 150)
                        .clipped()
                        .cornerRadius(12)
                }
            }
            Text(beachName)
                .font(.caption )
            
        }
    }
}

