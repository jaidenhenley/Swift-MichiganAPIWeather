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
    let beachID: Int
    
    var body: some View {
        
        NavigationLink {
            BeachView(beach: beach, beachID: beachID)
        } label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 101)
        }
    }
}
