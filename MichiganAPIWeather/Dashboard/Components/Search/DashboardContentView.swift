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
    @State private var suggestionsVM: SuggestedBeachViewModel?
    @Environment(\.colorScheme) var colorScheme
    
    private static let fallbackLocation = CLLocation(latitude: 44.7631, longitude: -85.6206)
    var nearby: [Beach] {
        Array(beachesNearMe(from: locationManager.userLocation ?? DashboardContentView.fallbackLocation, beaches: Beach.allBeaches).prefix(5))
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
                        Color(.systemTeal).opacity(0.14),
                        Color(.systemBackground),
                        Color(.systemBlue).opacity(0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
            ScrollView {
                VStack(spacing: 0) {
                    
                    ZStack(alignment: .topLeading) {
                        Image(.grandHaven1)
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
                                ForEach(nearby) { beach in
                                    NearBeachRow(images: beach.images, beach: beach, beachName: beach.beachName, beachID: beach.id)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
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
    func beachesNearMe(from location: CLLocation, beaches: [Beach]) -> [Beach] {
        beaches.sorted { (lhs: Beach, rhs: Beach) in
            let a = CLLocation(latitude: lhs.coordinates.latitude, longitude: lhs.coordinates.longitude)
            let b = CLLocation(latitude: rhs.coordinates.latitude, longitude: rhs.coordinates.longitude)
            return location.distance(from: a) < location.distance(from: b)
        }
    }

}
