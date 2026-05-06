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
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .font(.title2)
            
            Text("Warning! E. coli levels are high. Swimming may not be safe.")
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
        .alert("E. coli Warning", isPresented: $showDetail) {
            Button("OK", role: .cancel) {
            } } message: {
                Text("E. coli Warning \n\nSeverity: \(wq.status)\nExpires: \(formattedDate(wq.lastReading))")

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

