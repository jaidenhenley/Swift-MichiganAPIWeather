//
//  ActionButton.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/4/26.
//

import SwiftUI

struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
        }
        .buttonStyle(.plain)
    }
}

