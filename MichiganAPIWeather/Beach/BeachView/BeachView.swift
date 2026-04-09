//
//  BeachView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachView: View {
    @StateObject private var viewModel = BeachViewModel()
    let beach: BeachViewModel.ViewBeach
    let beachID: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    BeachHeader(image: beach.beachImage)
                    WeatherForecastRow().padding(.horizontal, 16)
                    Divider().foregroundStyle(.beachViewText).frame(height: 2)
                    CrowdMeterView(forecastCrowd: viewModel.forecastCrowd, forecastDays: viewModel.forecastDays)
                    BeachSummaryView(beachName: viewModel.beachName.isEmpty ? "" : viewModel.beachName, beachdescription: beach.beachDescription)
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
        }
        .task {
            await viewModel.selectBeach(beach, beachID: beachID)
        }
        .environmentObject(viewModel)
    }
}

