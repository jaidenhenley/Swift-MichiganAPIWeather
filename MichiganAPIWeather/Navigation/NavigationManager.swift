//
//  NavigationManager.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/27/26.
//

import Foundation
import SwiftUI

@Observable
class NavigationManager {
    static let shared = NavigationManager()
    
    var selectedTab: AppTab = .plan
    var planPath: [AppRoute] = []
    var favoritesPath: [AppRoute] = []
    
    func openBeach(id: Int, from tab: AppTab = .plan) {
        selectedTab = tab
        let route = [AppRoute.beachDetail(beachID: id)]
        switch tab {
        case .plan: planPath = route
        case .favorites: favoritesPath = route
        case .map: break
        }
    }
}
