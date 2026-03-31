//
//  MichiganWaterAPIService.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import Foundation

class MichiganWaterAPIService {
    private let baseURL = URL(string: "https://michiganwaterapi.onrender.com")
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchBeachDetails(beachID: Int) async throws -> BeachDetailResponse {
        let data = try await get(path: "/beaches/\(beachID)/details")
        return try JSONDecoder().decode(BeachDetailResponse.self, from: data)
    }

    func fetchAllBeaches() async throws -> [BeachSummary] {
        let data = try await get(path: "/beaches")
        return try JSONDecoder().decode([BeachSummary].self, from: data)
    }

    // MARK: - Private

    private func get(path: String) async throws -> Data {
        guard let base = baseURL, let url = URL(string: "\(base)\(path)") else {
            throw BeachError.badURL
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw BeachError.badResponse
        }

        switch http.statusCode {
        case 200...299:
            return data
        case 404:
            throw BeachError.notFound
        case 500...599:
            throw BeachError.serverError(http.statusCode)
        default:
            throw BeachError.badResponse
        }
    }
}

// MARK: - Beach Summary (list endpoint)

struct BeachSummary: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Errors

enum BeachError: LocalizedError {
    case badURL
    case badResponse
    case notFound
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .badResponse:
            return "Unexpected response from server"
        case .notFound:
            return "Beach not found"
        case .serverError(let code):
            return "Server error (\(code))"
        }
    }
}
