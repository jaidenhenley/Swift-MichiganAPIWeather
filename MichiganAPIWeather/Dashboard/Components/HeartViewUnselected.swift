//
//  HeartViewUnselected.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct HeartViewUnselected: View {
    @State private var isSelected = false
    
    var body: some View {

        Button {
            isSelected.toggle()
        } label: {
            ZStack {
                Image(systemName: isSelected ? "heart.fill" : "heart")
                    .font(.title)
                    .bold()
                    .foregroundStyle(isSelected ? .red : .white)
            }
            .frame(width: 44, height: 44)
            .background(.ultraThinMaterial, in: Circle())
        }
    }
}

#Preview {
    HeartViewUnselected()
}
