//
//  ForecastView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import SwiftUI

struct ForecastView: View {
    let days: [ForecastDay]

    var body: some View {
        if days.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text("Forecast")
                    .font(.headline)

                ForEach(days) { day in
                    ForecastRow(day: day)
                }
            }
        }
    }
}
