//
//  BeachView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachView: View {
    @Environment(BeachViewModel.self) var viewModel
    @State private var selectedImageIndex = 0
    let beach: Beach
    let beachID: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TabView(selection: $selectedImageIndex) {
                    ForEach(beach.images.indices, id: \.self) { index in
                        Image(beach.images[index])
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .tag(index)
                    }
                }
                .frame(height: 200)
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(beach.beachName)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.blueGreen)
                    HStack(spacing: 8) {
                        ForEach(beach.displayKeywords, id: \.label) { keyword in
                            HStack(spacing: 4) {
                                if let icon = keyword.icon {
                                    Image(systemName: icon)
                                        .font(.caption)
                                        .foregroundStyle(.blueGreen)
                                }
                                Text(keyword.label)
                                    .font(.caption)
                                    .foregroundStyle(.blueGreen)
                            }
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6).opacity(0.6))
                            .clipShape(Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Water Quality Alert
                    if let quality = viewModel.waterQuality?.first, quality.status != "safe" {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            
                            AlertCard(alert: AlertFeature(
                                event: "E. coli Warning",
                                headline: "E. coli levels measured at \(quality.value) \(quality.unit) on \(quality.lastReading). Swimming may not be safe.",
                                severity: quality.status == "unsafe" ? "Moderate" : "Minor",
                                urgency: "Expected",
                                effective: quality.lastReading,
                                expires: quality.lastReading
                            ))
                        }
                    }
                    
                    
                    if !viewModel.alerts.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                           
                            
                            ForEach(viewModel.alerts, id: \.event) { alert in
                                AlertCard(alert: alert)
                                    
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
                
                BeachHeader(image: beach.images[0])
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                WeatherForecastRow()
                    .padding(.top, 11)
                    .padding(.horizontal)
                
                
                    
                Divider()
                    .foregroundStyle(.beachViewText)
                    .frame(height: 3)
                    .padding(.vertical)
                
                Text("\(Image(systemName: "person.3.fill")) CROWD METER")
                    .foregroundStyle(.beachViewText)
                    .font(.footnote)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                CrowdMeterView(forecastCrowd: viewModel.forecastCrowd, forecastDays: viewModel.forecastDays)
                BeachSummaryView(beachName: viewModel.beachName.isEmpty ? "" : viewModel.beachName, beachdescription: beach.description)
                    .padding()
                ContactWebsitePhone()
                    .padding([.bottom, .horizontal])
                
                Spacer()
                    .frame(height: 100)
            }
            .ignoresSafeArea(edges: .top)
            .background(
                Image(.beachViewBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                FavoriteButtonView(beach: beach, isToolbarButton: true)
            }
        }
        .task {
            await viewModel.selectBeach(beach, beachID: beachID)
        }
        .environment(viewModel)
    }
}
