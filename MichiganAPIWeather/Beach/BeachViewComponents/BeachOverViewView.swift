//
//  BeachOverViewView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct BeachOverViewView: View {
    
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

#Preview {
    BeachOverViewView(beachName: "Grand Haven State Park", beachdescription: "Grand Haven State Park offers a quintessential Lake Michigan experience, defined by its iconic red lighthouse and sprawling pier. As the sun begins its descent over the freshwater horizon, the expansive sandy beach glows with a golden hue, drawing visitors from across the Midwest. The historic boardwalk stretches along the Grand River, providing a scenic path for locals and tourists alike to watch the Coast Guard cutters and sailboats navigate the channel. Whether you're here for the famous Musical Fountain, the annual Coast Guard Festival, or a quiet afternoon of kite flying in the brisk lake breeze, the park remains a crown jewel of the West Michigan shoreline, where the rhythmic sound of the waves meeting the shore creates a timeless soundtrack for summer memories.")
}
