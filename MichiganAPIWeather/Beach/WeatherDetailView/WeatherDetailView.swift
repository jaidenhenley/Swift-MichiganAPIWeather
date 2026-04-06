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
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    WeatherDashboard()
                    DailyForecastView()
                    
                    Spacer()
                }
            }
           
        }
        .environmentObject(viewModel)
    }
}




