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

        VStack {
            HStack {
                Image(systemName: stat.icon)
                Text(stat.name)
            }
            .font(.caption)
            .padding(.vertical, 20)
            Text("\(stat.value)\(stat.unit)")
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 78, height: 50)
                        .foregroundColor(.gray.opacity(0.2))
                )
            }
        .frame(width: 90)
        }
    }
