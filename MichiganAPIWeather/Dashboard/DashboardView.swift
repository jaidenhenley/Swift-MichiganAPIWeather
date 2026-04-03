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
    
    
    var favorites: [BeachEntry] = [
        BeachEntry(id: 1, name: "Belle Isle Beach", region: "Southeast", iconName: "building.2"),
        BeachEntry(id: 2, name: "Grand Haven State Park", region: "West", iconName: "leaf"),
        BeachEntry(id: 3, name: "Silver Lake Beach", region: "West", iconName: "sparkles"),
        BeachEntry(id: 4, name: "Sleeping Bear Dunes", region: "Northwest", iconName: "mountain.2"),
        BeachEntry(id: 5, name: "Tawas Point State Park", region: "Northeast", iconName: "bird"),
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
                        Text("Beach of the Day")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        NavigationLink {
                            BeachView(beach: .belleIsleBeach, beachID: 1)
                        } label: {
                            Image(.mainImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 340, height: 180)
                        }
                        
                        //Beaches near user
                        Text("Beaches near you")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
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
                        Text("Favorites")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        ForEach(favorites, id: \.self) { beach in
                            FavoritesRow(beachName: beach.name)
                        }
                        
                    }
                }
            }
        }
    }
}
