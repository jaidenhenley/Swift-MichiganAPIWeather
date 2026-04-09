//
//  HeartView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct HeartViewSelected: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 25, height: 25)
                .foregroundStyle(.ultraThinMaterial)
            Image(systemName: "heart.fill")
                .bold()
                .foregroundStyle(.red)
        }
       
    }
}

#Preview {
    HeartViewSelected()
}
