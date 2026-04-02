//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct DashboardView: View {
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
                        
                        //Beach of the Day
                        Text("Beach of the Day")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        NavigationLink {
                            PlaceholderView(text: "Beach of the day PlaceholderView")
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
                                NavigationLink {
                                    PlaceholderView(text: "Beach near you placeholder view")
                                } label: {
                                    Image(.smallImagePlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 101)
                                }
                                NavigationLink {
                                    PlaceholderView(text: "Beach near you placeholder view")
                                } label: {
                                    Image(.smallImagePlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 101)
                                }
                                NavigationLink {
                                    PlaceholderView(text: "Beach near you placeholder view")
                                } label: {
                                    Image(.smallImagePlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 101)
                                }
                                NavigationLink {
                                    PlaceholderView(text: "Beach near you placeholder view")
                                } label: {
                                    Image(.smallImagePlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 101)
                                }
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
