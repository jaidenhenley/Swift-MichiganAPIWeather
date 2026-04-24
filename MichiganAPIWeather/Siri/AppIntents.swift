//
//  AppIntents.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import AppIntents

struct GetBeachConditionsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Beach Conditions"
    static var description = IntentDescription("Check current conditions at a Michigan beach")
    
    
    @Parameter(title: "Beach Name")
    var beachName: String
    
    func perform() async throws -> some ReturnsValue<String> {
        guard let beach = Beach.allBeaches.first(where: {
            $0.beachName.lowercased().contains(beachName.lowercased())
        }) else {
            return .result(value: "I could not find a beach called \(beachName) in CoastCast.")
        }
        
        return .result(value: "Got it! Opening \(beach.beachName) in CoastCast.")
    }
}
