//
//  WeatherDashboard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI
import WeatherKit

struct WeatherDashboard: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(\.colorScheme) var colorScheme

    private var dayStats: [WeatherStat] {
        [
            WeatherStat(icon: "thermometer.variable", name: "AIR TEMP", value: viewModel.temperatureDisplay, unit: ""),
            WeatherStat(icon: "drop.fill", name: "WATER TEMP", value: viewModel.buoyData?.waterTempC.map { String(format: "%.0f", $0 * 9/5 + 32) } ?? "--", unit: "°"),
            WeatherStat(icon: "wind", name: "WIND", value: viewModel.forecastDays.first?.windSpeed ?? "--", unit: viewModel.forecastDays.first.map { $0.windDirection.initials } ?? "--"),
            WeatherStat(icon: "humidity", name: "HUMIDITY", value: viewModel.humidity, unit: ""),
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
            HStack {
                Text("TODAY")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
                if let attribution = viewModel.weatherAttribution {
                    Link(destination: attribution.legalPageURL) {
                        AsyncImage(url: colorScheme == .dark
                                   ? attribution.combinedMarkDarkURL
                                   : attribution.combinedMarkLightURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            EmptyView()
                        }
                        .frame(height: 12)
                    }
                }
            }
            .padding(.horizontal, 24)
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
