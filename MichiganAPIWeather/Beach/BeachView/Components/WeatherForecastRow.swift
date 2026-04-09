//
//  WeatherForecastRow.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherForecastRow: View {
    @EnvironmentObject var viewModel: BeachViewModel
    
    
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
                NavigationLink {
                    WeatherDetailView()
                        .environmentObject(viewModel)
                } label: {
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
            .padding(.horizontal)
            .environmentObject(viewModel)
        
    }
}


