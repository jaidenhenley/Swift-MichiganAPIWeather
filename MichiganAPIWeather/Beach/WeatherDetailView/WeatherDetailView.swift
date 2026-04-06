//
//  WeatherDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @State private var showingSheet = false
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    WeatherDashboard()
                    DailyForecastView(isShowingSheet: $showingSheet)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showingSheet) {
                HalfSheet(value: "50°")
                    .presentationDetents([.fraction(0.35), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}



#Preview {
    WeatherDetailView()
}
