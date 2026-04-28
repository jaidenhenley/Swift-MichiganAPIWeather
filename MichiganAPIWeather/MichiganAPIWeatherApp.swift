//
//  MichiganAPIWeatherApp.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import AppIntents
import SwiftData
import SwiftUI

@main
struct MichiganAPIWeatherApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var beachViewModel = BeachViewModel()
    @State private var locationManager = LocationManager()
    @State private var navManager = NavigationManager()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(beachViewModel)
                .environment(locationManager)
                .environment(navManager)
                .onAppear {
                    CoastCastShortcuts.updateAppShortcutParameters()
                }
        }
        .modelContainer(for: [FavoriteBeach.self, UserBeachPreferences.self])
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                BackgroundTaskManager.scheduleNext()
            }
        }
    }
    
    init() {
        URLCache.shared = URLCache(
            memoryCapacity: 10_000_000, // 10 MB
            diskCapacity: 50_000_000, // 50 MB
            diskPath: "coastcast_cache"
        )
        BackgroundTaskManager.registerTask()
    }
    
    

}
