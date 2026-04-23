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

            HStack(alignment: stat.unit == "°" ? .top : .firstTextBaseline, spacing: 1) {
                Text(stat.value)
                    .font(.caption2)
                    .bold()
                
                Text(stat.unit)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.top, stat.unit == "°" ? 2 : 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .frame(maxWidth: .infinity)
    }
}
