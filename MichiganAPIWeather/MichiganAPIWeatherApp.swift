//
//  MichiganAPIWeatherApp.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

@main
struct MichiganAPIWeatherApp: App {
    @State private var beachViewModel = BeachViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(beachViewModel)
        }
    }
    
    init() {
        URLCache.shared = URLCache(
            memoryCapacity: 10_000_000, // 10 MB
            diskCapacity: 50_000_000, // 50 MB
            diskPath: "coastcast_cache"
        )
    }
    
    

}
