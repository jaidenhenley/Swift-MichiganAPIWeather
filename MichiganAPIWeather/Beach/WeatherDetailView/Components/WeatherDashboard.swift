//
//  WeatherDashboard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDashboard: View {
    
    let dayStats = [
        WeatherStat(icon: "thermometer.variable", name: "AIR TEMP", value: "70", unit: "°"),
        WeatherStat(icon: "drop.fill", name: "WATER TEMP", value: "52", unit: "°"),
        WeatherStat(icon: "wind", name:"WIND", value: "20", unit: "km/h"),
        WeatherStat(icon: "humidity", name: "HUMIDITY", value: "64", unit: "%"),
        WeatherStat(icon: "sunset.fill", name: "SUNSET", value: "6:02", unit: "PM"),
    ]
    
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
                    .fill(Color.white.opacity(0.4))
            )
            .padding(.horizontal)
        }
    }
}
