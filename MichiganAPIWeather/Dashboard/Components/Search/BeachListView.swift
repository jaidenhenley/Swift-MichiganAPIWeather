//
//  BeachListView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct BeachListView: View {
    @Environment(BeachViewModel.self) var viewModel
    
    var body: some View {
        ScrollView {
            LazyVStack() {
                ForEach(viewModel.filteredBeaches) { beach in
                    NavigationLink {
                        BeachView(beach: beach, beachID: beach.id)
                    } label: {
                        BeachRow(beach: beach)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
