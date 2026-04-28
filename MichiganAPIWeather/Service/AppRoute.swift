//
//  AppRoute.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/27/26.
//

import Foundation

enum AppRoute: Hashable {
    case beachDetail(beachID: Int)
}

enum AppTab {
    case plan, map, favorites
}
