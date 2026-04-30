//
//  WeatherDescriptors.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct WeatherStat: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let value: String
    let unit: String
}
struct WeatherDescriptors: View {
    let stat: WeatherStat

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: stat.icon)
                Text(stat.name)
            }
            .font(.system(size: 8, weight: .bold))
            .foregroundColor(.primary)

            HStack(alignment: .firstTextBaseline, spacing: 1) {
                if stat.unit == "°" {
                    Text("\(stat.value)°")
                        .font(.headline)
                        .bold()
                } else {
                    Text(stat.value)
                        .font(.headline)
                        .bold()
                    
                    Text(stat.unit)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(stat.name), \(stat.value)\(stat.unit)")
    }
}
