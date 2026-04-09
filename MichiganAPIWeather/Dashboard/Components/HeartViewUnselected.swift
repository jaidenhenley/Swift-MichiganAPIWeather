//
//  HeartViewUnselected.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct HeartViewUnselected: View {
    var body: some View {

        ZStack {
            Circle()
                .frame(width: 25, height: 25)
                .foregroundStyle(.thinMaterial)
            Image(systemName: "heart")
                .bold()
                .foregroundStyle(.white)
        }

    }
}

#Preview {
    HeartViewUnselected()
}
