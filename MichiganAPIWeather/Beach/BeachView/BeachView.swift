//
//  BeachView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 3/19/26.
//

import SwiftUI

struct BeachView: View {
    @ObservedObject private var viewModel = BeachViewModel()
    let beach: BeachViewModel.ViewBeach
    let beachID: Int

    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                Color.gray
                    .opacity(0.1)
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        Spacer()
                        BeachHeader()
                        WeatherForecastRow().padding(.horizontal, 16)
                        CrowdMeterView()
                        
                        BeachSummaryView(beachName: viewModel.beachName.isEmpty ? "" : viewModel.beachName, beachdescription: beach.beachDescription)
                            .padding(.horizontal, 16)
                        
                        ContactWebsitePhone()
                            .padding([.bottom,.horizontal], 16)
                        
                    }
                }
            }
        }
        .task {
            await viewModel.selectBeach(beach, beachID: beachID)
        }
    }
}

