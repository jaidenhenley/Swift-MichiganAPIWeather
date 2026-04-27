//
//  IconStripView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct IconStripView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(BeachViewModel.self) var viewModel
    
    
    var dashboardCategories: [DashboardCategory] {
        [
            DashboardCategory(icon: "figure.hiking", title: "Hiking"),
            DashboardCategory(icon: "fish", title: "Fishing"),
            DashboardCategory(icon: colorScheme == .dark ? "tent.fill" : "tent", title: "Camping"),
            DashboardCategory(icon: "tree", title: "State Park")
        ]
    }
    var body: some View {
        @Bindable var viewModel = viewModel
        HStack(spacing: 30) {
            ForEach(dashboardCategories) { category in
                Button {
                    viewModel.isSearching = true
                    if category.title == "Camping" {
                        viewModel.filterCamping.toggle()
                    } else {
                        if viewModel.selectedKeywords.contains(category.title.lowercased()) {
                            viewModel.selectedKeywords.remove(category.title.lowercased())
                        } else {
                            viewModel.selectedKeywords.insert(category.title.lowercased())
                        }
                    }
                } label: {
                    DashboardIcons(icon: category.icon, title: category.title)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.beachViewText)
                
            }
        }
        .padding()
    }
}
