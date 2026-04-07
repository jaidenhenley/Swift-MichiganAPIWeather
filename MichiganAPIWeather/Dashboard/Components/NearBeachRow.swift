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
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 101)
                    .cornerRadius(12)
            }
            Text(beachName)
                .font(.caption )
            
        }
    }
}
