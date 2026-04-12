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
                    WeatherForecastRow().padding(.horizontal, 16)
                    Divider().foregroundStyle(.beachViewText).frame(height: 2)
                    CrowdMeterView(forecastCrowd: viewModel.forecastCrowd, forecastDays: viewModel.forecastDays)
                    BeachSummaryView(beachName: viewModel.beachName.isEmpty ? "" : viewModel.beachName, beachdescription: beach.description)
                        .padding(.horizontal, 16)
                    ContactWebsitePhone()
                        .padding([.bottom,.horizontal], 16)
                    
                }
                .background(
                    Image(.beachViewBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
            }
            .ignoresSafeArea(edges: [.top, .bottom])
        }
        .task {
            await viewModel.selectBeach(beach, beachID: beachID)
        }
        .environment(viewModel)
    }
}

