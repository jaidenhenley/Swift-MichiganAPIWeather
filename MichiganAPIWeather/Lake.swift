//
//  Lake.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

struct Lake: Codable, Identifiable {
    var id: UUID { lakeID }
    let lakeName: String
    let lakeDepth: Int
    let lakeID: UUID
    let region: String?
    let maxDepthFeet: Int?

    enum CodingKeys: String, CodingKey {
        case lakeName, lakeDepth, lakeID, region, maxDepthFeet
    }

    var depthDescription: String {
        if let maxFeet = maxDepthFeet {
            return "\(lakeDepth)m (max \(maxFeet)ft)"
        }
        return "\(lakeDepth)m"
    }
}
