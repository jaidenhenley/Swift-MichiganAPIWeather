//
//  BeachListView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct BeachListView: View {
    @Binding var query: String
    
    var filteredBeaches: [Beach] {
        if query.isEmpty {
            return Beach.allBeaches
        }
        return Beach.allBeaches.filter {
            $0.beachName.localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(filteredBeaches) { beach in
                    NavigationLink {
                        BeachView(beach: beach, beachID: beach.id)
                    } label: {
                        BeachRow(beach: beach)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
