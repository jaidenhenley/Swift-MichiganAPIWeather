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
            Image(.forecastBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 100)
                    
                    WeatherDashboard()
                    DailyForecastView()
                }
                .padding(.bottom)
            }
        }
        .environment(viewModel)
    }
}



