//
//  DailyForecastView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/11/26.
//

import SwiftUI

struct DailyForecastRowView: View {
    
    let day: ForecastDay
    let onTap: (ForecastDay) -> Void

    
    var body: some View {
        Button {
            onTap(day)
        } label: {
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 2){
                        Text(day.name)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blueGreen)
                        Text(day.dateText.uppercased())
                            .font(.caption)
                    }
                    .frame(width: 70, alignment: .leading)
                    HStack {
                        
                        
                        Image(systemName: day.icon)
                            .symbolVariant(.fill)
                            .font(.title2)
                            .frame(width: 35)
                        
                        Spacer()
                                                
                        Text(day.shortForecast)
                            .font(.title)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(day.temp)°")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(width: 50, alignment: .trailing)

                    }
                }
            
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
    }
}

