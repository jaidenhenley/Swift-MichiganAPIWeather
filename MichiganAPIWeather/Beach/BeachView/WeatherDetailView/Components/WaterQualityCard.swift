//
//  WaterQualityCard.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 5/6/26.
//

import SwiftUI

struct WaterQualityCard: View {
    @State private var showDetail = false
    
    let wq: WaterQuality
    let message: String
    let highConfidence: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .font(.title2)
            
            Text(message)
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
        .alert("Water Quality Advisory", isPresented: $showDetail) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("E. coli: \(wq.formattedValue)\nSampled: \(formattedDate(wq.lastReading))\nSource: \(wq.source)")
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

