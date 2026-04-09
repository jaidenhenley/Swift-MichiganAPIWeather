//
//  WeatherDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDetailView: View {
    @EnvironmentObject var viewModel: BeachViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                WeatherDashboard()
                DailyForecastView()
                
            }
            .background(
                Image(.forecastBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        }
        
        .environmentObject(viewModel)
    }
}



