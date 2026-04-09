//
//  ReusableHeadline.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/3/26.
//

import SwiftUI

struct Headline: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(.blueGreen)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title2)
            .padding(.horizontal, 16)
    }
}

#Preview {
    Headline(text: "Beach")
}
