//
//  BeachEntity.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/27/26.
//

import AppIntents
import Foundation


struct BeachEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Beach"
    static var defaultQuery = BeachQuery()

    let id: Int
    let name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct BeachQuery: EnumerableEntityQuery, EntityStringQuery {
    @MainActor
    func allEntities() async throws -> [BeachEntity] {
       Beach.allBeaches.map { BeachEntity(id: $0.id, name: $0.beachName) }
    }
    

    @MainActor
    func suggestedEntities() async throws -> [BeachEntity] {
       Beach.allBeaches.map { BeachEntity(id: $0.id, name: $0.beachName) }
    }

    @MainActor
    func entities(for identifiers: [Int]) async throws -> [BeachEntity] {
        Beach.allBeaches
            .filter { identifiers.contains($0.id) }
            .map { BeachEntity(id: $0.id, name: $0.beachName) }
    }
    
    @MainActor
    func entities(matching string: String) async throws -> [BeachEntity] {
         Beach.allBeaches
            .filter { $0.beachName.lowercased().contains(string.lowercased()) }
            .map { BeachEntity(id: $0.id, name: $0.beachName) }
    }
}

