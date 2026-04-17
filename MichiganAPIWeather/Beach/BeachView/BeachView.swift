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
        NavigationStack {
            ScrollView {
                VStack {
                    TabView(selection: $selectedImageIndex) {
                        ForEach(beach.images.indices, id: \.self) { index in
                            Image(beach.images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250, alignment: .top)
                                .clipped()
                                .tag(index)
                        }
                    }
                    .frame(height: 250)
                    .tabViewStyle(.page(indexDisplayMode: .always))

                    Spacer()
                    
                    BeachHeader(image: beach.images[0])
                        .padding()
                    WeatherForecastRow()
                        .padding(.horizontal)
                    Divider()
                        .foregroundStyle(.beachViewText)
                        .frame(height: 3)
                        .padding(.vertical, 8)
                    
                    Text("\(Image(systemName: "person.3.fill")) CROWD METER")
                        .foregroundStyle(.beachViewText)
                        .font(.footnote)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    CrowdMeterView(forecastCrowd: viewModel.forecastCrowd, forecastDays: viewModel.forecastDays)
                    BeachSummaryView(beachName: viewModel.beachName.isEmpty ? "" : viewModel.beachName, beachdescription: beach.description)
                        .padding(.horizontal)
                    ContactWebsitePhone()
                        .padding([.bottom,.horizontal])
                    
                    Spacer()
                        .frame(height: 100)
                        .foregroundStyle(.clear)
                    
                    
                }
                .background(
                    Image(.beachViewBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                       FavoriteButtonView(beach: beach, isToolbarButton: true)
                    }
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
        }
        .task {
            await viewModel.selectBeach(beach, beachID: beachID)
        }
        .environment(viewModel)
    }
}

