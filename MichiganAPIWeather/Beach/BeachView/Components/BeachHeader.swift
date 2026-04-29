//
//  TopOfPageBeachInformation.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct BeachHeader: View {
    @Environment(BeachViewModel.self) var viewModel
    let image: ImageResource
    
    var body: some View {
        HStack {
                VStack(spacing: 7) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .frame(width: 107, height: 107)
                            .foregroundColor(.beachHeaderBox)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.beachViewText, lineWidth: 0.5)
                            )
                        
                        VStack {
                            Text("AIR TEMP")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.beachViewText)
                            Text("\(viewModel.temperatureDisplay)")
                                .font(.largeTitle)
                        }
                    
                    }
                    
                    
                    
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 107, height: 107)
                        .foregroundColor(.beachHeaderBox)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.beachViewText, lineWidth: 0.5)
                        )
                    
                    VStack {
                        Text("WATER TEMP")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.beachViewText)
                        Text(viewModel.buoyData?.waterTempC.map { String(format: "%.1f°C", $0) } ?? "N/A")
                            .font(.largeTitle)
                    }
                    
                }
            }
            UVView()
                
        }
        .environment(viewModel)
    }
}
