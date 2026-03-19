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
                    Text("Belle Isle Beach")
                }
                NavigationLink {
                    BeachView(beachID: 2)
                } label: {
                    Text("Grand Haven State Park")
                }
                NavigationLink {
                    BeachView(beachID: 3)
                } label: {
                    Text("Silver Lake Beach")
                }
                NavigationLink {
                    BeachView(beachID: 4)
                } label: {
                    Text("Sleeping Bear Dunes")
                }
                NavigationLink {
                    BeachView(beachID: 5)
                } label: {
                    Text("Tawas Point State Park")
                }
            }
        }
        .padding()
    }
}
