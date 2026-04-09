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
                    .font(.title)
                    .foregroundStyle(.beachViewText)
                    .padding(20)
            }
            .buttonStyle(.glass)
            
            Text(title)
                .foregroundStyle(.beachViewText)
        }
    }
}

