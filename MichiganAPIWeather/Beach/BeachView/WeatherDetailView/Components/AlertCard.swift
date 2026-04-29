//
//  WaterWarning.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/23/26.
//

import SwiftUI

struct AlertCard: View {
    let alert: AlertFeature
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(alert.severity == "Moderate" ? .orange : .yellow)
                Text(alert.event)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(alert.headline)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("Expires: \(formattedDate(alert.expires))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.15))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.4), lineWidth: 1)
        )
    }
    
    func formattedDate(_ iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        guard let date = formatter.date(from: iso) else { return iso }
        let display = DateFormatter()
        display.dateFormat = "MMM d, h:mm a"
        return display.string(from: date)
    }
}

