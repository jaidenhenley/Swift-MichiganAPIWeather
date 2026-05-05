//
//  SListOfDaysDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct DailyForecastView: View {
    @State private var selectedDay: ForecastDay?
    @State private var infoDay: ForecastDay?
    @Environment(BeachViewModel.self) var viewModel

    var bestDay: ForecastDay? {
        viewModel.forecastDays.dropFirst().max(by: { a, b in
            if a.chanceOfPrecipitation != b.chanceOfPrecipitation {
                return a.chanceOfPrecipitation > b.chanceOfPrecipitation
            }
            return a.temp < b.temp
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.forecastDays.dropFirst()) { day in
                DailyForecastRow(day: day, onTap: { tappedDay in
                    selectedDay = tappedDay
                }, onInfoTap: { tappedDay in
                    infoDay = tappedDay
                }, isBestDay: day.id == bestDay?.id)
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
        .alert("Best Beach Day", isPresented: Binding(
            get: { infoDay != nil },
            set: { if !$0 { infoDay = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(infoDay?.name ?? "This day") is highlighted because it is the warmest upcoming day with the lowest chance of rain in this forecast.")
        }
    }
}

struct DailyForecastRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    let day: ForecastDay
    let onTap: (ForecastDay) -> Void
    let onInfoTap: (ForecastDay) -> Void
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
        let isDark = colorScheme == .dark
        
        // Adaptive "Golden" Palette
        let goldTop = isDark ? Color(hex: "3D3000") : Color(hex: "F1F2F3")
        let goldMid = isDark ? Color(hex: "2A2100") : Color(hex: "FEFCEC")
        let goldBottom = isDark ? Color(hex: "1A1A1A") : Color(hex: "D4E3EC")
        
        // Adaptive Standard Palette
        let standardFill = isDark ? Color.white.opacity(0.05) : Color.gray.opacity(0.1)

        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isBestDay ? Color.yellow.opacity(isDark ? 0.1 : 0.15) : standardFill)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    isBestDay ?
                        LinearGradient(
                            colors: [goldTop, goldMid, goldBottom],
                            startPoint: .top,
                            endPoint: .bottom
                        ) :
                        LinearGradient(
                            colors: [standardFill],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                )
        }
    }

    private var rowOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                isBestDay ? Color.yellow.opacity(colorScheme == .dark ? 0.5 : 1.0) : Color.clear,
                lineWidth: 1.5
            )
    }
    
    var body: some View {
        Button {
            onTap(day)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(day.name)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blueGreen)
                        Text(day.dateText.uppercased())
                            .font(.system(size: 10))
                        if isBestDay {
                            Text("BEST")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.yellow)
                        }
                    }
                    .frame(width: 60, alignment: .leading)
                    
                    HStack {
                        iconView
                        Spacer()
                        forecastView
                        Spacer()
                        tempView
                        Spacer()
                    }

                    if isBestDay {
                        Button {
                            onInfoTap(day)
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .padding(6)
                                .background(Color.white.opacity(colorScheme == .dark ? 0.12 : 0.55))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Explain best beach day")
                        .accessibilityHint("Shows why this forecast day is highlighted")
                    }
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            .background(rowBackground)
            .overlay(rowOverlay)
            .shadow(
                color: isBestDay ? Color.yellow.opacity(colorScheme == .dark ? 0.2 : 0.4) : Color.clear,
                radius: isBestDay ? 8 : 0
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(day.name), \(day.dateText), \(day.shortForecast), \(day.temp) degrees\(isBestDay ? ", best beach day" : "")")
        .accessibilityHint("Double tap for more details")
        .accessibilityAddTraits(.isButton)
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
