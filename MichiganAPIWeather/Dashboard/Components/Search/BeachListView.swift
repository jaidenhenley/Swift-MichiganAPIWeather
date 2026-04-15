//
//  BeachListView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftData
import SwiftUI

struct BeachListView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(\.modelContext) private var context

    @Query private var favorites: [FavoriteBeach]
    
    
    var body: some View {
        List(viewModel.filteredBeaches) { beach in
            ZStack {
                NavigationLink {
                    BeachView(beach: beach, beachID: beach.id)
                } label: {
                    EmptyView()
                }
                .opacity(0)
                
                BeachRow(beach: beach, isFavorited: favorites.contains(where: { $0.beachId == beach.id}))
            }
            .buttonStyle(.plain)
            .swipeActions {
                Button {
                    if let existing = favorites.first(where: { $0.beachId == beach.id }) {
                        context.delete(existing)
                    } else {
                        context.insert(FavoriteBeach(beachId: beach.id))
                    }
                } label: {
                    Label("Favorite", systemImage: "heart")
                }
                .tint(.orange)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
