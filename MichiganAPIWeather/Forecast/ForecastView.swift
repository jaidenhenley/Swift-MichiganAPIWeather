//
//  ForecastView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/27/26.
//

import SwiftUI

struct ForecastView: View {
    @StateObject var viewModel = ForecastViewModel()
    @StateObject var bViewModel = BeachViewModel()
    
    @Binding var number: Int
    
    var body: some View {
        Text(viewModel.shortForecast)
            .task {
                await viewModel.loadForecast(number: number)
            }
    }
}
