//
//  BeachView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachView: View {
    @StateObject private var viewModel = BeachViewModel()
        
        let beachID: Int
        
        var body: some View {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.secondary)
                } else {
                    Text(viewModel.beachName)
                        .font(.title2)
                        .bold()
                    
                    Text(viewModel.temperatureF)
                        .font(.system(size: 64, weight: .thin))
                    
                    Text(viewModel.condition)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 24) {
                        Label(viewModel.windMPH, systemImage: "wind")
                        Label(viewModel.windDirection, systemImage: "location.north.fill")
                        Label(viewModel.humidity, systemImage: "humidity")
                    }
                    .font(.callout)
                    
                    HStack(spacing: 24) {
                        Label(viewModel.visibility, systemImage: "eye")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    
                    if viewModel.activeAlerts > 0 {
                        Label("\(viewModel.activeAlerts) active alert(s)", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.callout)
                    }
                }
            }
            .padding()
            .task {
                await viewModel.loadBeach(id: beachID)
            }
        }
}
