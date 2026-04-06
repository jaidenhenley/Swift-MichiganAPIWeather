//
//  ContactWebsitePhone.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/4/26.
//

import SwiftUI

struct ContactWebsitePhone: View {
    var body: some View {

        HStack (spacing: 15) {
            ActionButton(icon: "globe", title: "Website") {
                // URL
            }
            ActionButton(icon: "map", title: "Location") {
                // Open Maps action
            }
            ActionButton(icon: "phone.fill", title: "Call") {
                // Phone call
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    ContactWebsitePhone()
}
