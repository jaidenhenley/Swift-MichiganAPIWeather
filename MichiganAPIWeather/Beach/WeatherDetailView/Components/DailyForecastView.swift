//
//  SListOfDaysDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct DailyForecastView: View {
    @Binding var isShowingSheet: Bool
    let days = ["TOMORROW", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "MONDAY"]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(days, id: \.self) { day in
                Button {
                    isShowingSheet = true
                } label: {
                    VStack(alignment: .leading) {
                        Text(day)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
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
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.4))
        )
        .padding(.horizontal)
    }
}
