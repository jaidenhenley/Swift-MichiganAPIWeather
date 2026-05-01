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
    let aliases: [String]

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: "Michigan Beach"
        )
    }
}


struct BeachQuery: EnumerableEntityQuery, EntityStringQuery {
    @MainActor
    func allEntities() async throws -> [BeachEntity] {
        Beach.allBeaches.map { BeachEntity(id: $0.id, name: $0.beachName, aliases: $0.aliases) }
    }

    @MainActor
    func suggestedEntities() async throws -> [BeachEntity] {
        Beach.allBeaches.map { BeachEntity(id: $0.id, name: $0.beachName, aliases: $0.aliases) }
    }

    @MainActor
    func entities(matching string: String) async throws -> [BeachEntity] {
        let query = string.lowercased()
        return Beach.allBeaches
            .filter { beach in
                beach.beachName.lowercased().contains(query) ||
                beach.aliases.contains { $0.lowercased().contains(query) }
            }
            .sorted(by: { a, b in
                a.beachName.lowercased().hasPrefix(query) && !b.beachName.lowercased().hasPrefix(query)
            })
            .map { BeachEntity(id: $0.id, name: $0.beachName, aliases: $0.aliases) }
    }

    @MainActor
    func entities(for identifiers: [Int]) async throws -> [BeachEntity] {
        Beach.allBeaches
            .filter { identifiers.contains($0.id) }
            .map { BeachEntity(id: $0.id, name: $0.beachName, aliases: $0.aliases) }
    }
}
