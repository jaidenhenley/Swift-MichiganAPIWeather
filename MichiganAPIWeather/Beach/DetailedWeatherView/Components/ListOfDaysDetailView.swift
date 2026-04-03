//
//  SListOfDaysDetailView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct ListOfDaysDetailView: View {
    
    let days = ["TOMMROW", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "MONDAY"]
    var body: some View {
        
        ForEach(days, id: \.self) { day in
            VStack(alignment: .leading) {
                Text(day)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            .listRowSeparator(.hidden)            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .padding(.horizontal)
        }
    }
}

#Preview {
    ListOfDaysDetailView()
}
