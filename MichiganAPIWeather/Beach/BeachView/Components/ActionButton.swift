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
        
        VStack {
            Button(action: action) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.beachViewText)
                    .frame(width: 64, height: 64)
                    .overlay(
                        Circle()
                            .stroke(.beachViewText)
                    )
            }
            Text(title)
                .foregroundStyle(.beachViewText)
        }
    }
}

