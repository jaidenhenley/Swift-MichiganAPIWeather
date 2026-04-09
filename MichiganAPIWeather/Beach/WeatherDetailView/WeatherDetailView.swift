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
        ZStack(alignment: .top) {
            Image(.forecastBackground)
                .resizable()
                
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    WeatherDashboard()
                    DailyForecastView()
                    
                }
            }
           
        }
        .environmentObject(viewModel)
    }
}



