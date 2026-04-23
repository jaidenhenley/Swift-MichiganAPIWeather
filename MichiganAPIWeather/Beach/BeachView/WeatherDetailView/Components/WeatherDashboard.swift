//
//  WeatherDashboard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDashboard: View {
    @Environment(BeachViewModel.self) var viewModel

    private var dayStats: [WeatherStat] {
        [
            WeatherStat(icon: "thermometer.variable", name: "AIR TEMP", value: viewModel.temperatureDisplay, unit: ""),
            WeatherStat(icon: "drop.fill", name: "WATER TEMP", value: "52", unit: "°"),
            WeatherStat(icon: "wind", name: "WIND", value: viewModel.forecastDays.first?.windSpeed ?? "--", unit: viewModel.forecastDays.first.map { $0.windDirection.initials } ?? "--"),
            WeatherStat(icon: "humidity", name: "HUMIDITY", value: viewModel.humidity, unit: "%"),
            WeatherStat(icon: "sunrise.fill", name: "SUNRISE", value: viewModel.forecastDays.first?.sunrise ?? "--", unit: ""),
            WeatherStat(icon: "sunset.fill", name: "SUNSET", value: viewModel.forecastDays.first?.sunset ?? "--", unit: ""),
            WeatherStat(icon: "sunset.max.fill", name: "UV INDEX", value: String(viewModel.uvIndex), unit: ""),
            WeatherStat(
                icon: "cloud.rain",
                name: "CHANCE OF RAIN",
                value: viewModel.chanceOfPrecipToPercent(chance: viewModel.chanceOfPrecipitation),
                unit: ""
            )

        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TODAY")
                .font(.headline)
                .bold()
                .foregroundColor(.primary)
                .padding(.leading, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(dayStats) { item in
                        WeatherDescriptors(stat: item)
                            .frame(width: 100)
                    }
                }
                .padding(.horizontal, 20) 
            }
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customWhite.opacity(0.4))
            )
            .padding(.horizontal)
        }
    }
}
