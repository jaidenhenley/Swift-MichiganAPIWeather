//
//  WeatherForecastRow.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherForecastRow: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 25) {
                    ForEach(viewModel.hourForecast.enumerated(), id: \.offset) {index, hour in
                        HourColumn(hour: hour, label: index == 0 ? "Now" : hour.time)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .scrollIndicators(.hidden)
            NavigationLink(value: AppRoute.weatherDetail){
                    HStack {
                        Text("SEE MORE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.beachViewText)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .buttonStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.lightBlue)
            )
            .shadow(
                color: colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.2),
                radius: 8
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.crowdMeterBar, lineWidth: 0.5)
            )
            .environment(viewModel)
        
    }
}


