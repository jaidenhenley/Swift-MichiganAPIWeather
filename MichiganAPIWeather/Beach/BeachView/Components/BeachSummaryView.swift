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
        VStack(alignment: .leading, spacing: 4){
            Text("OVERVIEW")
                .font(.caption2)
                .bold()
                .foregroundColor(.beachViewText)
            
            Text(beachName)
                .font(.title2)
                .bold()
                .foregroundColor(.beachViewText)
            
            Text(beachdescription)
                .font(.subheadline)

                .foregroundColor(.beachViewText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.beachDescriptionBackground)
        )
    }
}

