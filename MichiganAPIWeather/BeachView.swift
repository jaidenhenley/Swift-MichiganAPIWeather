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
    let beachName: String

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isLoading && !viewModel.hasData {
                    loadingView
                } else if let error = viewModel.errorMessage, !viewModel.hasData {
                    errorView(error)
                } else {
                    temperatureCard
                    conditionsGrid
                    alertsBanner
                }
            }
            .padding()
        }
        .navigationTitle(beachName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleUnit()
                } label: {
                    Text(viewModel.useCelsius ? "°C" : "°F")
                        .font(.headline)
                }
            }
        }
        .refreshable {
            await viewModel.loadBeach(id: beachID)
        }
        .task {
            await viewModel.loadBeach(id: beachID)
        }
    }

    // MARK: - Subviews

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading weather data...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.icloud")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
            Button("Retry") {
                Task {
                    await viewModel.loadBeach(id: beachID)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }

    private var temperatureCard: some View {
        VStack(spacing: 8) {
            Text(viewModel.temperatureDisplay)
                .font(.system(size: 72, weight: .ultraLight, design: .rounded))

            Text(viewModel.condition)
                .font(.title3)
                .foregroundStyle(.secondary)

            if let stationName = viewModel.stationName {
                Text("Station: \(stationName)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            if let timestamp = viewModel.lastUpdated {
                Text("Updated: \(timestamp)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var conditionsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ], spacing: 16) {
            weatherTile(icon: "wind", title: "Wind", value: viewModel.windMPH)
            weatherTile(icon: "location.north.fill", title: "Direction", value: viewModel.windDirection)
            weatherTile(icon: "humidity", title: "Humidity", value: viewModel.humidity)
            weatherTile(icon: "eye", title: "Visibility", value: viewModel.visibility)

            if let dewpoint = viewModel.dewpoint {
                weatherTile(icon: "drop.degreesign", title: "Dewpoint", value: dewpoint)
            }

            if let pressure = viewModel.pressure {
                weatherTile(icon: "barometer", title: "Pressure", value: pressure)
            }
        }
    }

    private func weatherTile(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body.weight(.semibold))
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var alertsBanner: some View {
        if viewModel.activeAlerts > 0 {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.yellow)
                Text("\(viewModel.activeAlerts) active alert(s)")
                    .font(.callout.weight(.medium))
                Spacer()
            }
            .padding()
            .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
