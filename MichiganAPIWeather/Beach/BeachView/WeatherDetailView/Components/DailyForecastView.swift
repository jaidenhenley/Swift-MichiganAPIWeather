//
//  SListOfDaysDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct DailyForecastView: View {
    @State private var selectedDay: ForecastDay?
    @Environment(BeachViewModel.self) var viewModel

    var bestDay: ForecastDay? {
        viewModel.forecastDays.dropFirst().max(by: { a, b in
            if a.chanceOfPrecipitation != b.chanceOfPrecipitation {
                return a.chanceOfPrecipitation > b.chanceOfPrecipitation
            }
            return a.temp < b.temp
        })
    }

    // in the ForEach:
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.forecastDays.dropFirst()) { day in
                DailyForecastRow(day: day, isBestDay: day.id == bestDay?.id) { tappedDay in
                    selectedDay = tappedDay
                }
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.customWhite.opacity(0.4))
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
    var isBestDay: Bool = false

    private var iconView: some View {
        Image(systemName: day.icon)
            .font(.title)
    }

    private var forecastView: some View {
        Text(day.shortForecast)
            .font(.title)
            .foregroundStyle(.secondary)
    }

    private var tempView: some View {
        Text("\(day.temp)°")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }
    
    private var rowBackground: some View {
        let base = RoundedRectangle(cornerRadius: 12)
            .fill(isBestDay ? Color.yellow.opacity(0.15) : Color.gray.opacity(0.1))
        let gradient = RoundedRectangle(cornerRadius: 12)
            .fill(
                isBestDay ?
                    LinearGradient(
                        colors: [
                            Color(hex:"F1F2F3"),
                            Color(hex:"FEFCEC"),
                            Color(hex:"D4E3EC")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ) :
                    LinearGradient(
                        colors: [Color.gray.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
            )
        return ZStack {
            base
            gradient
        }
    }

    private var rowOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(isBestDay ? Color(.yellow) : Color.clear, lineWidth: 1.5)
    }
    
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
                        iconView
                        Spacer()
                        forecastView
                        Spacer()
                        tempView
                        Spacer()
                    }
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            .background(rowBackground)
            .overlay(rowOverlay)
            .shadow(
                color: isBestDay ? Color(.yellow).opacity(0.4) : Color.clear,
                radius: isBestDay ? 8 : 0
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
