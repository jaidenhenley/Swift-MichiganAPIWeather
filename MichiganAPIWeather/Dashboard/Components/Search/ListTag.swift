//
//  ListTag.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/10/26.
//

import SwiftUI

struct ListTag: View {
    let tagName: String
    
    var body: some View {
        Text(tagName)
            .foregroundStyle(.beachViewText)
            .font(.caption)
    }
}

#Preview {
    ListTag(tagName: "Fishing")
}
