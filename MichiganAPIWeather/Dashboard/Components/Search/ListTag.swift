//
//  ListTag.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/10/26.
//

import SwiftUI

struct ListTag: View {
    let tagName: String
    var icon: String? = nil
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.caption)
            }
            Text(tagName)
                .font(.caption)
        }
        .foregroundStyle(.beachViewText)
    }
}
