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
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                WeatherDashboard()
                DailyForecastView()

            }
        }
        .background(
            Image(.forecastbackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
        )
        .environment(viewModel)
    }
}
