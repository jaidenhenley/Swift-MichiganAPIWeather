//
//  IndividualWeatherDayView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI



struct HourColumn: View {
    let hour: HourForecast
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .foregroundColor(.primary)
            
            Image(systemName: hour.icon)
                .symbolVariant(.fill)
                
                .frame(width: 30, height: 30)
            
            Text(hour.temp)
        }
        .font(.subheadline)
            .bold()
        .frame(maxWidth: .infinity)
    }
}


