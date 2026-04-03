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
            HStack {
                Text(viewModel.beachName)
                    .font(.subheadline)
                    .opacity(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                
                Image(.star)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(.horizontal, 8)
            }
            .frame(width: 339, height: 71)
            .background(
                Color.gray.opacity(0.2)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
        }
        .buttonStyle(.plain)
        
       
    }
}

