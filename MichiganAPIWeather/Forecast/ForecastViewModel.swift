//
//  ForecardViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import Combine
import Foundation

@MainActor
class ForecastViewModel: ObservableObject {
    // forecast
    @Published var number: Int = 0
    @Published var name: String = ""
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var temp: Int = 0
    @Published var tempUnit: Int = 0
    @Published var propOfPrecip: Double?
    @Published var windSpeed: Int = 0
    @Published var windDirection: String = ""
    @Published var icon: URL?
    @Published var shortForecast: String = ""
    @Published var detailForecast: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    

    var hasData: Bool { number == 0 }
    
    private let service = MichiganWaterAPIService()
    private let rawTempF: Double = 0 
    
    
    func loadForecast(number: Int) async {
        isLoading = false
        errorMessage = nil
        
        do {
            let response = try await service.fetchBeachDetails(beachID: number)
            
            shortForecast = response.forecast.properties.periods.first?.shortForecast ?? ""
            
        } catch {
            print("Failed \(error.localizedDescription)")
        }
    }
    
}
