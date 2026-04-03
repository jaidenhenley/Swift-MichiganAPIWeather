//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = BeachViewModel()
    @State private var searchText = ""
    
    
    var favorites: [BeachViewModel.ViewBeach] = [
        .belleIsleBeach, .grandHavenStatePark, .silverLakeBeach, .sleepingBear, .tawasPointStatePark
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.2)
                    .ignoresSafeArea()
                ScrollView {
                    
                    Spacer()
                        .frame(height: 20)
                    VStack {
                        CustomSearchBar(text: $searchText)
                            .padding(.horizontal, 8)
                        
                        //Beach of the Day
                        Headline(text: "Beach of the day")
                        NavigationLink {
                            BeachView(beach: .belleIsleBeach, beachID: 1)
                        } label: {
                            Image(.mainImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 340, height: 180)
                        }
                        
                        //Beaches near user
                        Headline(text: "Beaches near you")
                        ScrollView(.horizontal) {
                            HStack {
                                NearBeachRow(image: .smallImagePlaceholder, beach: .belleIsleBeach, beachID: 1)
                                NearBeachRow(image: .smallImagePlaceholder, beach: .grandHavenStatePark, beachID: 2)
                                NearBeachRow(image: .smallImagePlaceholder, beach: .silverLakeBeach, beachID: 3)
                                NearBeachRow(image: .smallImagePlaceholder, beach: .sleepingBear, beachID: 4)
                                NearBeachRow(image: .smallImagePlaceholder, beach: .tawasPointStatePark, beachID: 5)
                                
                            }
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                        
                        //Favorites
                        Headline(text: "Favorites")
                        
                        ForEach(favorites, id: \.self) { beach in
                            FavoritesRow(image: .star, beach: beach, beachID: 1)
                        }
                    }
                }
            }
        }
    }
}
