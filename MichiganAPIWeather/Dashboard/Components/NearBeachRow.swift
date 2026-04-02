//
//  NearBeachesRow.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct NearBeachRow: View {
    let image: ImageResource
    
    var body: some View {
        
        NavigationLink {
            PlaceholderView(text: "Beach near you placeholder view")
        } label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 101)
        }
    }
}

#Preview {
    NearBeachRow(image: .smallImagePlaceholder)
}
