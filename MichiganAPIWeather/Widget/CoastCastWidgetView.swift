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
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.beachName)
                        .bold()
                        .font(.headline)
                    Text(entry.condition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("💧 \(entry.waterTemp)")
                    Text("👥 \(entry.crowdLevel)")
                    Text("☀️ UV \(entry.uvIndex)")
                }
                .font(.caption)
            }
            .padding()
            .containerBackground(.teal.opacity(0.2), for: .widget)
    }
}
