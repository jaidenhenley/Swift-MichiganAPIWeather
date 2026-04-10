//
//  ContentView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachEntry: Identifiable, Hashable {
    let id: Int
    let name: String
    let region: String
    let iconName: String
}

struct ContentView: View {
    @State private var searchText = ""
    @StateObject private var favorites = FavoritesManager()

    @State private var viewModel = BeachViewModel()
    
    var body: some View {
        DashboardView()
            .environment(viewModel)
    }
}
