//
//  SListOfDaysDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct DailyForecastView: View {
    @State private var isShowingSheet = false
    @State private var selectedDay: ForecastDay?
    @Environment(BeachViewModel.self) var viewModel

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.forecastDays.dropFirst()) { day in
                DailyForecastRow(day: day) { tappedDay in
                    selectedDay = tappedDay
                    
                }
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.4))
        )
        .padding(.horizontal)
        .sheet(item: $selectedDay) { day in
            ForecastSheet(day: day)
                .presentationDetents([.fraction(0.35), .medium])
                .presentationDragIndicator(.visible)
        }

        
    }
}

struct DailyForecastRow: View {
    
    let day: ForecastDay
    let onTap: (ForecastDay) -> Void

    
    var body: some View {
        Button {
            onTap(day)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    VStack{
                        Text(day.name)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blueGreen)
                        Text(day.dateText.uppercased())
                    }
                    HStack {
                        
                        
                        Image(systemName: day.icon)
                            .font(.title)
                        
                        Spacer()
                        
                        Text(day.shortForecast)
                            .font(.title)
                            .foregroundStyle(.secondary)
                        
                        Spacer()

                        Text("\(day.temp)°")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Spacer()

                    }
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

