//
//  ForecastRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import SwiftUI

struct ForecastRow: View {
    let day: ForecastDay
    
    var body: some View {
        HStack {
            Text(day.name)
                .frame(width: 100, alignment: .leading)
            Spacer()
            
            Text("\(day.temp)")
                .bold()
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}
