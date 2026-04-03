//
//  WeatherDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDetailView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            VStack {
                WeatherDashboard()
                DailyForecastView()
                Spacer()
            }
        }
    }
}



#Preview {
    WeatherDetailView()
}
