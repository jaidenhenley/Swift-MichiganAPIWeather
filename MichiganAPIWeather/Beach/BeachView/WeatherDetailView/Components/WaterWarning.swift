//
//  WaterWarning.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/23/26.
//

import SwiftUI

struct WaterWarning: View {
    var body: some View {
        
        HStack {
            Image(systemName: "alarm")
            Text("Warning! This lake has been flagged for unsafe waters. ")
                .bold()
            Image(systemName: "i.circle")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.alertGray)
        )
    }
}

#Preview {
    WaterWarning()
}
