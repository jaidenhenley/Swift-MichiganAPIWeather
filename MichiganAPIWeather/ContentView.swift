//
//  ContentView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    BeachView(beachID: 1)
                } label: {
                    Text("Beach 1")
                }
                NavigationLink {
                    BeachView(beachID: 2)
                } label: {
                    Text("Beach 2")
                }
                NavigationLink {
                    BeachView(beachID: 3)
                } label: {
                    Text("Beach 3")
                }
                NavigationLink {
                    BeachView(beachID: 4)
                } label: {
                    Text("Beach 4")
                }
                NavigationLink {
                    BeachView(beachID: 5)
                } label: {
                    Text("Beach 5")
                }
            }
        }
        .padding()
    }
}
