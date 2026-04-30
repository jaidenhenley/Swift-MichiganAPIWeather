//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import CoreLocation
import SwiftData
import SwiftUI

struct DashboardContentView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @State private var suggestionsVM: SuggestedBeachViewModel?

    var nearby: [Beach]? {
        guard let userLocation = locationManager.userLocation else { return nil }
        return Beach.allBeaches.sortedByDistance(from: userLocation, limit: 5)
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            if colorScheme == .dark {
                Color(.navy)
                    .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.78, green: 0.85, blue: 0.90),
                        Color(red: 0.90, green: 0.93, blue: 0.96),
                        .white,
                        Color(red: 0.90, green: 0.93, blue: 0.96),
                        Color(red: 0.78, green: 0.85, blue: 0.90)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
            ScrollView {
                VStack(spacing: 0) {
                    
                    ZStack(alignment: .topLeading) {
                        Image(.coastCastDash2)
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
                                            .font(.footnote)
                                            .foregroundStyle(.blueGreen)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 12)
                                            .background(Color.yellow)
                                            .clipShape(Capsule())
                                    }
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                }
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 20)
                        }
                        .frame(height: 320)
                    }
                    
                    VStack(spacing: 0) {
                        IconStripView()
                        Divider()
                        if let nearby {
                            Headline(text: "Beaches near you")
                                .padding(.vertical)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(nearby) { beach in
                                        NearBeachRow(images: beach.images, beach: beach,
                                                     beachName: beach.beachName, beachID: beach.id)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .scrollIndicators(.hidden)
                        } else {
                            LocationPromptCard {
                                locationManager.openSetting()
                            }
                        }
                        Divider()
                            .padding()
                        Headline(text: "You Might Like")
                            .padding(.bottom)
                        MightLikeScrollView(suggestions: suggestionsVM?.suggestions ?? [])
                            .environment(\.font, nil)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .task(id: locationManager.userLocation) {
                let vm: SuggestedBeachViewModel
                if let existing = suggestionsVM {
                    vm = existing
                } else {
                    vm = SuggestedBeachViewModel(
                        favoritesRepo: LocalFavoritesRepository(context: context)
                    )
                    suggestionsVM = vm
                }
                await vm.loadSuggestions(userLocation: locationManager.userLocation)
            }
        }
    }
}

struct LocationPromptCard: View {
    let onEnable: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "location.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.blueGreen)
            
            Text("See beaches near you")
                .font(.headline)
            
            Text("Enable location to sort Michigan beaches by distance.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onEnable) {
                Text("Enable Location")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.blueGreen)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.yellow)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}
