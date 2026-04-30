//
//  FavoriteBeach.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/10/26.
//

import SwiftData
import Foundation

@Model
class FavoriteBeach {
    var beachId: Int

    init(beachId: Int) {
        self.beachId = beachId
    }
}
