//
//  CoastCastWidgetBundle.swift
//  CoastCastWidget
//
//  Created by George Clinkscales on 4/24/26.
//

import WidgetKit
import SwiftUI

@main
struct CoastCastWidgetBundle: WidgetBundle {
    var body: some Widget {
        CoastCastWidget()
        CoastCastLiveActivity()
    }
}
