//
//  WeatherDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDetailView: View {
    @Environment(BeachViewModel.self) var viewModel

    var body: some View {
        ZStack {
            // 1. The Background Layer
            Image(.forecastBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea() // This makes it go edge-to-edge

            // 2. The Content Layer
            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 100) // Adjusts where the content starts
                    
                    WeatherDashboard()
                    DailyForecastView()
                }
                .padding(.bottom) // Prevents content from hitting the home indicator
            }
        }
        .environment(viewModel)
    }
}



