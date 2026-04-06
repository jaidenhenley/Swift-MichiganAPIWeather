//
//  WeatherRow.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/3/26.
//

import SwiftUI


struct WeatherRow: View {
    let leftLabel: String
    let leftIcon: String
    let rightLabel: String
    let rightIcon: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: leftIcon)
                        Text(leftLabel)
                    }
                    .font(.caption).foregroundColor(.secondary)
                    Text(value).font(.headline)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(rightLabel)
                        Image(systemName: rightIcon)
                    }
                    .font(.caption).foregroundColor(.secondary)
                    Text(value).font(.headline)
                }
            }
            .padding(.horizontal)
            Divider().padding(.horizontal)
        }
    }
}
