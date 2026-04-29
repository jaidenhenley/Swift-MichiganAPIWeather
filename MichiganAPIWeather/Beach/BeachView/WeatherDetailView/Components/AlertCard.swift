//
//  WaterWarning.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/23/26.
//

import SwiftUI

struct AlertCard: View {
    let alert: AlertFeature
    @State private var showDetail = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .font(.title2)
            
            Text(alert.headline)
                .font(.subheadline)
                .bold()
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button {
                showDetail = true
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.primary)
                    .font(.title3)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray5))
        .cornerRadius(16)
        .alert(alert.event, isPresented: $showDetail) {
            Button("OK", role: .cancel) {
            } } message: {
                Text("\(alert.headline)\n\nSeverity: \(alert.severity)\nExpires: \(formattedDate(alert.expires))")

            }
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

struct AlertDetailSheet: View {
    let alert: AlertFeature
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(alert.event)
                                .font(.title2)
                                .bold()
                            Text(alert.severity)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    Text(alert.headline)
                        .font(.body)
                    
                    if !alert.effective.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Issued")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formattedDate(alert.effective))
                                .font(.subheadline)
                        }
                    }
                    
                    if !alert.expires.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Expires")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formattedDate(alert.expires))
                                .font(.subheadline)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Alert Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
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
