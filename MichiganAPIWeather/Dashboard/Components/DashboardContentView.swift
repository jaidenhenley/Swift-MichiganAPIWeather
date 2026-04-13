//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct DashboardContentView: View {
    @Environment(BeachViewModel.self) var viewModel
    
    var favorites: [Beach] = Beach.allBeaches.filter { [4, 2, 3, 1, 5].contains($0.id) }
    
    var body: some View {
        @Bindable var viewModel = viewModel
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
                            .overlay {
                                LinearGradient(
                                    colors: [.black.opacity(0.7), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        VStack(alignment: .leading, spacing: 12) {
                            
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("""
                                         Overwhelmed?
                                         Explore With Ease.
                                         """)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                
                                
                                HStack {
                                    Button {
                                        viewModel.isSearching = true
                                    } label: {
                                        Text("Plan Your Trip")
                                            .font(.subheadline)
                                            .foregroundStyle(.blueGreen)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 12)
                                            .background(Color.yellow)
                                            .clipShape(Capsule())
                                    }
                                    
                                    
                                    
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
