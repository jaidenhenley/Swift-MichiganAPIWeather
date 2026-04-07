//
//  IndividualWeatherDayView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI



struct HourColumn: View {
    let hour: HourForecast
    
    var body: some View {
        VStack(spacing: 6) {
            Text(hour.time)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.primary)
            
            Image(systemName: hour.icon)
                .symbolVariant(.fill)
                .font(.system(size: 20))
            
            Text(hour.temp)
                .font(.system(size: 14, weight: .bold))
        }
        .frame(maxWidth: .infinity)
    }
}


