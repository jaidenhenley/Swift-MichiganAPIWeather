//
//  SelectBeachIntent.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import AppIntents
import WidgetKit

struct SelectBeachIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Beach"
    static var description = IntentDescription("Choose a beach to display")

    @Parameter(title: "Beach")
    var beach: BeachEntity?
}
