//
//  HeartViewUnselected.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct HeartViewUnselected: View {
    var body: some View {

        Button {
            
        } label: {
            ZStack {
                Image(systemName: "heart")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)
            .background(.ultraThinMaterial, in: Circle())
        }
    }
}

#Preview {
    HeartViewUnselected()
}
