//
//  FavoritesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct FavoritesRow: View {
    let beachName: String
    
    var body: some View {
        NavigationLink {
            PlaceholderView(text: "This will be a favorite beach")
        } label: {
            HStack {
                Text(beachName)
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

#Preview {
    FavoritesRow(beachName: "Sleeping Bear Dunes")
}
