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
        HStack() {
            ZStack {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 220, height: 220)
            }
            
                VStack(spacing: 5) {
                    ZStack {
                        VStack (alignment: .leading) {
                            Text("AIR TEMP")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.temperatureDisplay)")
                                .font(.largeTitle)
                                .bold()
                        }
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 105, height: 105)
                        .foregroundColor(.gray.opacity(0.2))
                }
                ZStack {
                    VStack (alignment: .leading) {
                        Text("WATER TEMP")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.buoyData?.waterTempC.map { String(format: "%.1f°C", $0) } ?? "N/A")
                            .font(.largeTitle)
                            .bold()
                    }
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 105, height: 105)
                        .foregroundColor(.gray.opacity(0.2))
                }
            }
        }
    }
}
