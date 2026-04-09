//
//  FavoritesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct FavoritesRow: View {
    @StateObject private var viewModel = BeachViewModel()
    let image: ImageResource
    let beach: BeachViewModel.ViewBeach
    let beachID: Int
    
    var body: some View {
        NavigationLink {
            BeachView(beach: beach, beachID: beachID)
        } label: {
            
        }
        
       
    }
}

