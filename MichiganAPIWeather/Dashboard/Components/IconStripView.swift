//
//  IconStripView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct IconStripView: View {
    @Environment(\.colorScheme) var colorScheme

    var dashboardCategories: [DashboardCategory] {
        [
            DashboardCategory(icon: "figure.hiking", title: "Trails"),
            DashboardCategory(icon: "fish", title: "Fishing"),
            DashboardCategory(icon: colorScheme == .dark ? "familyIconWhite" : "familyIcon", title: "Family"),
            DashboardCategory(icon: "tree", title: "State Park")
        ]
    }
    var body: some View {
        
            HStack(spacing: 30) {
                ForEach(dashboardCategories) { category in
                    DashboardIcons(icon: category.icon, title: category.title)
                }
            }
            .padding()
    }
}

#Preview {
    IconStripView()
}
