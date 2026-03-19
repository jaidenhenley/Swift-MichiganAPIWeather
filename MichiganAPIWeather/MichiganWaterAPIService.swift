//
//  MichiganWaterAPIService.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

class MichiganWaterAPIService {
    private let baseURL = "https://michiganwaterapi.onrender.com"
    
    func fetchBeachDetails(beachID: Int) async throws -> BeachDetailResponse {
        guard let url = URL(string: "\(baseURL)/beaches/\(beachID)/details") else {
            throw BeachError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BeachError.badResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(BeachDetailResponse.self, from: data)
    }
}

enum BeachError: Error {
    case badURL
    case badResponse
}
