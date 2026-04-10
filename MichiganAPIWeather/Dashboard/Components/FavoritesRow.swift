//
//  FavoritesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct FavoritesRow: View {
    @Environment(BeachViewModel.self) var viewModel
    let image: ImageResource
    let beach: Beach
    let beachID: Int
    
    var body: some View {
        NavigationLink {
            BeachView(beach: beach, beachID: beach.id)
        } label: {
            
        }
        
       
    }
}

