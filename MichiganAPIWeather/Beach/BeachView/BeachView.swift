//
//  BeachView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI
import WeatherKit

struct BeachView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedImageIndex = 0
    @State private var showCrowdMeterAlert: Bool = false
    let beach: Beach
    let beachID: Int
    var isSheet: Bool = false


    private func activeAlerts(at date: Date) -> [AlertFeature] {
        viewModel.alerts.filter { $0.isActive(at: date) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TabView(selection: $selectedImageIndex) {
                    ForEach(beach.images.indices, id: \.self) { index in
                        beachImage(at: index)
                    }
                }
                .frame(height: 200)
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 200)
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(beach.beachName)
                        .accessibilityAddTraits(.isHeader)
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
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(keyword.label)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Water Quality Alert
                    if let quality = viewModel.waterQuality,
                       quality.isRecentEnoughToShow,
                       quality.status != "safe",
                       let message = quality.alertMessage {
                        WaterQualityCard(wq: quality, message: message, highConfidence: quality.isHighConfidence)
                    }
                    TimelineView(.periodic(from: .now, by: 60)) { context in
                        let activeAlerts = activeAlerts(at: context.date)

                        if !activeAlerts.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(activeAlerts, id: \.event) { alert in
                                    AlertCard(alert: alert)
                                        .accessibilityLabel("\(alert.event). \(alert.headline)")
                                        .accessibilityHint("Tap info for more details")
                                }
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

                if let attribution = viewModel.weatherAttribution {
                    Link(destination: attribution.legalPageURL) {
                        AsyncImage(url: attribution.combinedMarkLightURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            EmptyView()
                        }
                        .frame(height: 12)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                    .padding(.top, 8)
                }

                Divider()
                    .foregroundStyle(.beachViewText)
                    .frame(height: 3)
                    .padding(.vertical, 12)
                    .accessibilityHidden(true)

                HStack {
                    Text("\(Image(systemName: "person.3.fill")) CROWD METER")
                        .accessibilityLabel("Crowd Meter")
                        .accessibilityLabel("Crowd Meter")
                        .accessibilityAddTraits(.isHeader)
                        .foregroundStyle(.beachViewText)
                        .font(.footnote)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    
                    Button("", systemImage: "info.circle") {
                        showCrowdMeterAlert.toggle()
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 8)
                }
                
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
                    .accessibilityHidden(true)
            )
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                FavoriteButtonView(beach: beach, isToolbarButton: true)
                    .accessibilityLabel("Favorite \(beach.beachName)")
            }
            if isSheet {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .alert("Crowd Meter", isPresented: $showCrowdMeterAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The crowd meter predicts how busy a beach will be based on temperature, wind, precipitation, and whether it's a holiday or weekend. Predictions run on-device using a machine learning model trained on historical visitation data.")
        }
        .task {
            await viewModel.selectBeach(beach, beachID: beachID)
        }
        .environment(viewModel)
    }
    
    private func beachImage(at index: Int) -> some View {
        Image(beach.images[index])
            .resizable()
            .scaledToFill()
            .clipped()
            .tag(index)
            .accessibilityLabel("Beach photo \(index + 1) of \(beach.images.count)")
    }
}


