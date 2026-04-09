//
//  TopOfPageBeachInformation.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct BeachHeader: View {
    @EnvironmentObject var viewModel: BeachViewModel
    let image: ImageResource
    
    var body: some View {
        HStack {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 220, height: 220)
            
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 105, height: 105)
                            .foregroundColor(.beachHeaderBox)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.beachViewText, lineWidth: 1)
                            )
                        
                        VStack {
                            Text("AIR TEMP")
                                .font(.caption)
                                .foregroundColor(.beachViewText)
                            Text("\(viewModel.temperatureDisplay)")
                                .font(.largeTitle)
                        }
                    
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 105, height: 105)
                        .foregroundColor(.beachHeaderBox)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.beachViewText, lineWidth: 1)
                        )
                    
                    VStack {
                        Text("WATER TEMP")
                            .font(.caption)
                            .foregroundColor(.beachViewText)
                        Text(viewModel.buoyData?.waterTempC.map { String(format: "%.1f°C", $0) } ?? "N/A")
                            .font(.largeTitle)
                    }
                    
                }
            }
        }
    }
}
