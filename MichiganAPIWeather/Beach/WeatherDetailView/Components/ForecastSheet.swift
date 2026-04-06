//
//  HalfSheet.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/3/26.
//

import SwiftUI



struct ForecastSheet: View {
    let day: ForecastDay
    
    var body: some View {
        
        
        VStack(spacing: 12) {

            Text("Daily Details")
                .font(.title3).fontWeight(.bold)
                .padding(.bottom, 10)

            WeatherRow(leftLabel: "SUNRISE", leftIcon: "sunrise.fill",
                       rightLabel: "SUNSET", rightIcon: "sunset.fill", rightValue: "6:42am", leftValue: "7:00pm")
            
            WeatherRow(leftLabel: "HUMIDITY", leftIcon: "humidity.fill",
                       rightLabel: "WIND", rightIcon: "wind", rightValue: "12mph", leftValue: "N/A")
            
            WeatherRow(leftLabel: "AIR TEMP", leftIcon: "thermometer.medium",
                       rightLabel: "WATER TEMP", rightIcon: "water.waves", rightValue: "N/A", leftValue: String(day.temp) )
            
            Spacer()
            
        }
        .padding(20)
        .background(Color(.systemBackground))
    }
}
