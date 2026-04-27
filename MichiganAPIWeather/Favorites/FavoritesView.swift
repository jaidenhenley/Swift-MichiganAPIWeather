//
//  FavoritesView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/10/26.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    
    @Query private var favorites: [FavoriteBeach]
    @Environment(BeachViewModel.self) private var beachViewModel
    @Environment(LocationManager.self) private var locationManager
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("beachAlertEnabled") private var alertEnabled = false
    @AppStorage("beachAlertTime") private var alertTimeInterval: Double = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!.timeIntervalSince1970
    @State private var showingAlertSheet = false
    
    private var alertTime: Binding<Date> {
        Binding(
            get: { Date( timeIntervalSince1970: alertTimeInterval) },
                set: { alertTimeInterval = $0.timeIntervalSince1970 }
        )
    }
    
    private var favoriteBeaches: [Beach] {
        let favoriteIDs = Set(favorites.map(\.beachId))
        return Beach.allBeaches.filter { favoriteIDs.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteBeaches.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart.slash",
                        description: Text("Beaches you favorite will show up here.")
                    )
                } else {
                    BeachListView(beachList: favoriteBeaches, sortByDistance: false, distanceRange: .all)
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if alertEnabled {
                            alertEnabled = false
                            NotificationManager.shared.cancelAlert()
                        } else {
                            alertEnabled = true
                            NotificationManager.shared.requestPermission()
                            reschedule()
                            showingAlertSheet = true
                        }
                    } label: {
                        Image(systemName: alertEnabled ? "bell.fill" : "bell.slash")
                    }
                }
            }
            .sheet(isPresented: $showingAlertSheet) {
                VStack(spacing: 24) {
                    Text("Daily Beach Alert")
                        .font(.headline)
                    Text("We'll notify you about your top-scored favorite beach.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    DatePicker("Alert time", selection: alertTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: alertTimeInterval) { _, _ in reschedule() }
                    Button("Done") {
                        showingAlertSheet = false
                    }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
                .presentationDetents([.height(260)])
            }
        }
    }

    private func reschedule() {
        let favorites = favoriteBeaches
        let favoriteIDs = Set(favorites.map(\.id))
        let repo = InlineFavoritesRepository(favoriteIDs: favoriteIDs)
        let scoringService = BeachScoringService(favoritesRepo: repo)
        let weatherService = WeatherKitService()
        
        Task {
            await NotificationManager.shared.refresh(
                favorites: favorites,
                scoringService: scoringService,
                weatherService: weatherService,
                userLocation: locationManager.userLocation,
                at: Date(timeIntervalSince1970: alertTimeInterval)
            )
        }
    }
}

private struct InlineFavoritesRepository: FavoritesRepository {
    let favoriteIDs: Set<Int>

    func isFavorite(beachID: Int) -> Bool {
        favoriteIDs.contains(beachID)
    }

    func allFavorites() -> [Beach] {
        Beach.allBeaches.filter { favoriteIDs.contains($0.id) }
    }
}

#Preview {
    FavoritesView()
}
