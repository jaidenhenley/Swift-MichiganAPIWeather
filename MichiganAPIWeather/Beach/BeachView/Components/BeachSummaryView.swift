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
        VStack(alignment: .leading, spacing: 6){
            Text("OVERVIEW")
                .font(.caption)
                .bold()
                .foregroundColor(.beachViewText)
            
            Text(beachName)
                .font(.title2)
                .bold()
                .foregroundColor(.beachViewText)
            
            Text(beachdescription)
                .foregroundColor(.beachViewText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.beachDescriptionBackground)
        )
    }
}

