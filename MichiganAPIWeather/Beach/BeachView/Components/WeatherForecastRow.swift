//
//  WeatherForecastRow.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherForecastRow: View {
    let forecast = [
        WeatherDay(time: "Now", weatherImage: "sun.max.fill", temperature: 52),
        WeatherDay(time: "1PM", weatherImage: "cloud.sun.fill", temperature: 54),
        WeatherDay(time: "2PM", weatherImage: "cloud.fill", temperature: 53),
        WeatherDay(time: "3PM", weatherImage: "cloud.rain.fill", temperature: 50),
        WeatherDay(time: "4PM", weatherImage: "cloud.bolt.fill", temperature: 48),
        WeatherDay(time: "5PM", weatherImage: "sun.max.fill", temperature: 51)
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 25) {
                    ForEach(forecast, id: \.self) { day in
                        HourColumn(day: day)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            
            NavigationLink {
                WeatherDetailView()
            } label: {
                HStack {
                    Text("SEE MORE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .buttonStyle(.plain)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
        )
        .padding(.horizontal)
    }
}

#Preview {
    WeatherForecastRow()
}
