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
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.primary)
            
            Image(systemName: hour.icon)
                .symbolVariant(.fill)
                .font(.system(size: 20))
                .frame(width: 30, height: 30)
            
            Text(hour.temp)
                .font(.system(size: 14, weight: .bold))
        }
        .frame(maxWidth: .infinity)
    }
}


