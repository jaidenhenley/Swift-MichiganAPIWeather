//
//  BeachEntity.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import AppIntents

struct BeachEntity: AppEntity {
    let id: Int
    let name: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Beach"
    static var defaultQuery =  BeachQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}


struct BeachQuery: EntityQuery {
    func entities(for identifiers: [Int]) async throws -> [BeachEntity] {
        Beach.allBeaches
            .filter { identifiers.contains($0.id) }
            .map { BeachEntity(id: $0.id, name: $0.beachName) }
    }
    
    func suggestedEntities() async throws -> [BeachEntity] {
        Beach.allBeaches.map { BeachEntity(id: $0.id, name: $0.beachName) }
    }
}
