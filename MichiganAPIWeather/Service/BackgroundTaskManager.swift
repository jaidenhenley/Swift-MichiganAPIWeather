//
//  BackgroundTaskManager.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/27/26.
//


import BackgroundTasks
import SwiftData
import CoreLocation

struct BackgroundTaskManager {
    static let taskID = "com.coastcast.beachrefresh"

    static func registerTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskID, using: nil) { task in
            BackgroundTaskManager.handle(task: task as! BGAppRefreshTask)
        }
    }

    static func scheduleNext() {
        let request = BGAppRefreshTaskRequest(identifier: taskID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    private static func handle(task: BGAppRefreshTask) {
        BackgroundTaskManager.scheduleNext()

        let taskHandle = Task {
            await BackgroundTaskManager.runRefresh()
            task.setTaskCompleted(success: true)
        }

        task.expirationHandler = {
            taskHandle.cancel()
        }
    }

    private static func runRefresh() async {
        URLCache.shared.removeAllCachedResponses()
        let container = try? ModelContainer(for: FavoriteBeach.self, UserBeachPreferences.self)
        guard let container else { return }

        let context = ModelContext(container)
        let favorites = (try? context.fetch(FetchDescriptor<FavoriteBeach>())) ?? []
        guard !favorites.isEmpty else { return }

        let favoriteBeaches = Beach.allBeaches.filter { beach in
            favorites.contains { $0.beachId == beach.id }
        }
        guard !favoriteBeaches.isEmpty else { return }

        let alertTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "beachAlertTime"))
        let alertEnabled = UserDefaults.standard.bool(forKey: "beachAlertEnabled")
        guard alertEnabled else { return }

        let favoriteIDs = Set(favoriteBeaches.map(\.id))
        let repo = BackgroundFavoritesRepository(favoritesIDs: favoriteIDs)
        let scoringService = BeachScoringService(favoritesRepo: repo)
        let weatherService = WeatherKitService()
        let apiService = MichiganWaterAPIService()

        await NotificationManager.shared.refresh(
            favorites: favoriteBeaches,
            scoringService: scoringService,
            weatherService: weatherService,
            apiService: apiService,
            userLocation: nil,
            at: alertTime
        )
    }
}

struct BackgroundFavoritesRepository: FavoritesRepository {
    let favoritesIDs: Set<Int>

    func isFavorite(beachID: Int) -> Bool {
        favoritesIDs.contains(beachID)
    }

    func allFavorites() -> [Beach] {
        Beach.allBeaches.filter { favoritesIDs.contains($0.id) }
    }
}
