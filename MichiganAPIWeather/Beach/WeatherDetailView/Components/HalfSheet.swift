//
//  HalfSheet.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/3/26.
//

import SwiftUI



struct HalfSheet: View {
    let value: String
    var body: some View {
        
        
        VStack(spacing: 12) {

            Text("Daily Details")
                .font(.title3).fontWeight(.bold)
                .padding(.bottom, 10)

            WeatherRow(leftLabel: "SUNRISE", leftIcon: "sunrise.fill",
                       rightLabel: "SUNSET", rightIcon: "sunset.fill", value: "6:42 AM")
            
            WeatherRow(leftLabel: "HUMIDITY", leftIcon: "humidity.fill",
                       rightLabel: "WIND", rightIcon: "wind", value: "12%")
            
            WeatherRow(leftLabel: "AIR TEMP", leftIcon: "thermometer.medium",
                       rightLabel: "WATER TEMP", rightIcon: "water.waves", value: "72°")
            
            Spacer()
            
        }
        .padding(20)
        .background(Color(.systemBackground))
    }
}
