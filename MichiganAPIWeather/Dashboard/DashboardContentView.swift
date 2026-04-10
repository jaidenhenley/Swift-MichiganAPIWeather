//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct DashboardContentView: View {
    @StateObject private var viewModel = BeachViewModel()
    @Binding var searchText: String
    
    
    var favorites: [Beach] = Beach.allBeaches.filter { [4, 2, 3, 1, 5].contains($0.id) }
    
    var body: some View {
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
                                    ForEach(favorites) { beach in
                                        NearBeachRow(image: beach.image, beach: beach, beachName: beach.beachName, beachID: beach.id)
                                    }
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
            }
    }
}
