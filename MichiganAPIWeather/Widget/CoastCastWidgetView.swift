//
//  CoastCastWidget.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import SwiftUI
import WidgetKit

struct CoastCastWidgetView: View {
    let entry: BeachWidgetEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        default:
            smallView
        }
    }

    var smallView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.beachName)
                .bold()
                .font(.caption)
                .lineLimit(1)
            Text("💧 \(entry.waterTemp)")
                .font(.caption)
            Text("👥 \(entry.crowdLevel)")
                .font(.caption)
            Text("☀️ UV \(entry.uvIndex)")
                .font(.caption)
        }
        .padding()
        .containerBackground(.teal.opacity(0.2), for: .widget)
    }

    var mediumView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [.teal.opacity(0.4), .cyan.opacity(0.25)],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .overlay {
                        Image(systemName: "water.waves")
                            .font(.system(size: 30))
                            .foregroundStyle(.white.opacity(0.3))
                    }

                Text(entry.beachName)
                    .font(.system(.subheadline, weight: .heavy))
                    .foregroundStyle(Color(red: 0.1, green: 0.35, blue: 0.35))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 110)

            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    WidgetTempCard(label: "AIR TEMP", value: entry.airTemp)
                    WidgetTempCard(label: "WATER TEMP", value: entry.waterTemp)
                }

                HStack(spacing: 4) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 11))
                    Text("CROWD METER")
                        .font(.system(size: 11, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color(red: 0.15, green: 0.35, blue: 0.35))

                WidgetCrowdBar(level: entry.crowdLevel)
            }
        }
        .padding(12)
        .containerBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.65, green: 0.82, blue: 0.80),
                    Color(red: 0.82, green: 0.85, blue: 0.60)
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .widget
        )
    }
}

private struct WidgetTempCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color(red: 0.25, green: 0.50, blue: 0.50))
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(red: 0.1, green: 0.35, blue: 0.35))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.white.opacity(0.45), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct WidgetCrowdBar: View {
    let level: String

    private var filledSegments: Int {
        switch level.lowercased() {
        case "low": return 2
        case "moderate": return 4
        case "high": return 6
        default: return 0
        }
    }

    private var barColor: Color {
        switch level.lowercased() {
        case "low": return .green
        case "moderate": return .yellow
        case "high": return .red
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<6, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(index < filledSegments ? barColor : Color(red: 0.75, green: 0.80, blue: 0.75).opacity(0.5))
                    .frame(height: 12)
            }
        }
    }
}
