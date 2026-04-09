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
        do {
            let response = try JSONDecoder().decode(BeachDetailResponse.self, from: data)

            print("[API] ✅ Beach: \(response.beach ?? "nil")")

            if let buoy = response.buoyData {
                print("[API]   Buoy: source=\(buoy.source)"
                    + " water=\(buoy.waterTempC.map { "\($0)°C" } ?? "nil")"
                    + " waves=\(buoy.waveHeightM.map { "\($0)m" } ?? "nil")"
                    + " wind=\(buoy.windSpeedMph.map { "\($0) mph" } ?? "nil")")
            } else {
                print("[API]   Buoy: nil")
            }

            print("[API]   Alerts: \(response.alerts.count)")
            print("[API]   Traffic: \(response.traffic.count) segment(s)")

            for (i, t) in response.traffic.enumerated() {
                print("[API]     [\(i)] speed=\(t.currentSpeed.map { "\($0)" } ?? "nil")"
                    + " freeFlow=\(t.freeFlowSpeed.map { "\($0)" } ?? "nil")"
                    + " closures=\(t.roadClosures.map { "\($0)" } ?? "nil")")
            }

            print("[API]   Holiday: \(response.holiday)")

            return response
        } catch {
            if let raw = String(data: data, encoding: .utf8) {
                print("[API] ❌ Decode failed for beachID \(beachID). Raw JSON:\n\(raw)")
            } else {
                print("[API] ❌ Decode failed for beachID \(beachID). \(data.count) bytes")
            }
            throw error
        }
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

        print("[API] \(http.statusCode) \(url.absoluteString) — \(data.count) bytes")

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
