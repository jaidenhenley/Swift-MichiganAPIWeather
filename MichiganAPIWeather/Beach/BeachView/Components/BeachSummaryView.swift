//
//  BeachOverViewView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct BeachSummaryView: View {
    
    let beachName: String
    let beachdescription: String
    
    var body: some View {
        VStack(alignment: .leading ){
            Text("OVERVIEW")
                .font(.caption)
            
            Text(beachName)
                .font(.callout)
                .bold()
                .padding(.vertical,5)
            Text(beachdescription)
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2)))
    }
}

