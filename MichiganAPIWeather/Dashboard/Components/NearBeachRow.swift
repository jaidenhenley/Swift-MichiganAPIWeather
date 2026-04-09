//
//  NearBeachesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct NearBeachRow: View {
    @StateObject private var viewModel = BeachViewModel()
    let image: ImageResource
    let beach: BeachViewModel.ViewBeach
    let beachName: String
    let beachID: Int
    
    var body: some View {
        VStack {
            NavigationLink {
                BeachView(beach: beach, beachID: beachID)
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 95, height: 132)
                        .clipped()
                        .cornerRadius(12)
                    
                    HeartViewUnselected()
                        .padding(.top,5)
                        .padding(.trailing,5)
                }
            }
            Text(beachName)
                .font(.caption )
            
        }
    }
}

