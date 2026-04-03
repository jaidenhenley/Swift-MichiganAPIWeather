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

struct IndividualWeatherDayView: View {
    let day: WeatherDay
    
    var body: some View {
        VStack {
            Text(day.time)
                .bold()
                .padding(4)
            Image(systemName: day.weatherImage)
                .padding(4)
            Text("\(day.temperature)°")
        }
    }
    
}


