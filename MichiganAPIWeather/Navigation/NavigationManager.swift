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
    var path: [AppRoute] = []
    
    func openBeach(id: Int) {
        selectedTab = .plan
        path = [.beachDetail(beachID: id)]
    }
}
