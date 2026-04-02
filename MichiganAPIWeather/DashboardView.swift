//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    
    var favorites: [Beach] = []
    
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
                        
                        List(favorites) { _ in
                            
                        }
                        
                    }
                }
            }
        }
    }
}
