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
                LinearGradient(
                    colors: [
                        Color(.systemTeal).opacity(0.14),
                        Color(.systemBackground),
                        Color(.systemBlue).opacity(0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            Image(.grandHaven)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .clipped()
                            
                            
                            
                            VStack(alignment: .leading, spacing: 12) {
                                CustomSearchBar(text: $searchText)
                                    .padding(.top, 90)
                                    .padding(.horizontal, 16)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Overwhelmed?")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(.lightBlue)
                                    
                                    Text("Explore With Ease.")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(.lightBlue)
                                    
                                    HStack {
                                        Text("Plan Your Trip")
                                            .font(.subheadline)
                                            .foregroundStyle(.blueGreen)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(Color.yellow)
                                            .clipShape(Capsule())
                                        
                                        Spacer()
                                        
                                        Text("Grand Haven (2014)")
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                            .padding(.trailing)
                                    }
                                }
                                .padding(.leading, 16)
                                .padding(.bottom, 20)
                            }
                            .frame(height: 380)
                        }
                        
                        VStack(spacing: 0) {
                            IconStripView()
                            Divider()
                            Headline(text: "Beaches near you")
                                .padding(.vertical)
                            ScrollView(.horizontal) {
                                HStack {
                                    NearBeachRow(image: .belleIsle, beach: .belleIsleBeach, beachName: "Belle Isle Beach", beachID: 1)
                                    NearBeachRow(image: .grandHaven, beach: .grandHavenStatePark, beachName: "Grand Haven State Park", beachID: 2)
                                    NearBeachRow(image: .silverLake, beach: .silverLakeBeach, beachName: "Silver Lake Beach", beachID: 3)
                                    NearBeachRow(image: .sleepingBear, beach: .sleepingBear, beachName: "Sleeping Bear Dunes", beachID: 4)
                                    NearBeachRow(image: .smallImagePlaceholder, beach: .tawasPointStatePark, beachName: "Tawaw Point State Park", beachID: 5)
                                }
                                .padding(.horizontal, 16)
                            }
                            .scrollIndicators(.hidden)
                            Divider()
                                .padding()
                            Headline(text: "You Might Like")
                                .padding(.bottom)
                            MightLikeScrollView()
                        }
                    }
                }
                
                .ignoresSafeArea(edges: .top)
                .toolbarVisibility(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    DashboardView()
}
