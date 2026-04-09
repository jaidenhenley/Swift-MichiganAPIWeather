//
//  CustomSearchBa.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search", text: $searchText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .glassEffect()
        .padding(.horizontal)
    }
}
