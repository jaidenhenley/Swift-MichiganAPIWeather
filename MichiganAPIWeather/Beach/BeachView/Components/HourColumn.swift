//
//  IndividualWeatherDayView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherDay: Identifiable, Hashable {
    
    
    let id = UUID()
    let time: String
    let weatherImage: String
    let temperature: Int
}

struct HourColumn: View {
    let day: WeatherDay
    
    var body: some View {
        VStack(spacing: 6) {
            Text(day.time)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.primary)
            
            Image(systemName: day.weatherImage)
                .symbolVariant(.fill)
                .font(.system(size: 20))
            
            Text("\(day.temperature)°")
                .font(.system(size: 14, weight: .bold))
        }
        .frame(maxWidth: .infinity)
    }
}


