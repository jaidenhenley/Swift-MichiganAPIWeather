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
                    .font(.system(size: 36))
                    .foregroundStyle(.beachViewText)
                    .frame(width: 100, height: 100)
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

