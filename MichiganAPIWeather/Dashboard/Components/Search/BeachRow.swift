//
//  BeachRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct BeachRow: View {
    let beach: BeachViewModel.ViewBeach
    
    var body: some View {
        HStack(spacing: 12) {
            Image(beach.beachImage)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(beach.beachName)
                    .font(.headline)
                Text(beach.beachDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.footnote)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
