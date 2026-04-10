//
//  BeachView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachView: View {
    @Environment(BeachViewModel.self) var viewModel
    let beach: Beach
    let beachID: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image(beach.image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250, alignment: .top)
                        .clipped()
                    
                    Spacer()
                    BeachHeader(image: beach.image)
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

