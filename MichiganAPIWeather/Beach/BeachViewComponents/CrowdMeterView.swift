//
//  CrowdMeterView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct CrowdMeterView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.3.fill")
                Text("CROWD METER")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)
            
        }
    }
}

#Preview {
    CrowdMeterView()
}
