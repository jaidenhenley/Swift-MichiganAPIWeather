//
//  ButtonToTrackBeachWidget.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import SwiftUI
import ActivityKit

struct ButtonToTrackBeachWidget: View {
    @Environment(BeachViewModel.self) var viewModel
    let beach: Beach

    var body: some View {
        Button("Track This Beach") {
            let attributes = BeachActivityAttributes(beachName: beach.beachName)
            let state = BeachActivityAttributes.ContentState(
                crowdLevel: viewModel.todayCrowd?.label ?? "Unknown",
                waterTemp: viewModel.temperatureDisplay,
                uvIndex: viewModel.uvIndex
            )

            do {
                let activity = try Activity<BeachActivityAttributes>.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil)
                )
                print("[LiveActivity] started: \(activity.id)")
            } catch {
                print("[LiveActivity] error: \(error)")
            }
        }
    }
}
