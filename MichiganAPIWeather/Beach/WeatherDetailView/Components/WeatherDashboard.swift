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
        WeatherStat(icon: "water.drop", name: "WATER TEMP", value: "52", unit: "°"),
        WeatherStat(icon: "wind", name:"WIND", value: "20", unit: "km/h"),
        WeatherStat(icon: "humidity", name: "HUMIDITY", value: "64", unit: "%"),
        WeatherStat(icon: "sunset", name: "SUNSET", value: "6:02", unit: ""),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("TODAY")
                .font(.caption)
                .bold()
                .foregroundColor(.black)
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(dayStats) { item in
                        WeatherDescriptors(stat: item)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white).opacity(0.2)
                )
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    WeatherDashboard()
}
