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
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
            .padding(.horizontal, 16)
            .bold()
    }
}
