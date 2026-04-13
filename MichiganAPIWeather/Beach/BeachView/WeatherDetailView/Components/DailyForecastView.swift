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
                DailyForecastRowView(day: day) { tappedDay in
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


