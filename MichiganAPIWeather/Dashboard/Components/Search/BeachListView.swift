//
//  BeachListView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct BeachListView: View {
    @Binding var query: String
    
    var filteredBeaches: [BeachViewModel.ViewBeach] {
        if query.isEmpty {
            return BeachViewModel.ViewBeach.allCases
        }
        return BeachViewModel.ViewBeach.allCases.filter {
            $0.beachName.localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(filteredBeaches, id: \.beachID) { beach in
                    NavigationLink {
                        BeachView(beach: beach, beachID: beach.beachID)
                    } label: {
                        BeachRow(beach: beach)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
