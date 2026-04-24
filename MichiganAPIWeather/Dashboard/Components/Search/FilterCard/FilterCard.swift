//
//  FilterCard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/14/26.
//

import CoreLocation
import SwiftUI

struct FilterCard: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var distanceRange: DistanceRange
    
    var body: some View {
        VStack (spacing:0) {
            
            HStack {
                if !viewModel.selectedKeywords.isEmpty {
                    Button("Clear All") {
                        withAnimation(.snappy) {
                            viewModel.selectedKeywords.removeAll()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    Text("Clear All")
                        .font(.subheadline)
                        .opacity(0)
                }

                Spacer()

                Text("FILTER & SORT")
                    .bold()
                    .fontDesign(.rounded)

                Spacer()

                Text("Clear All")
                    .font(.subheadline)
                    .opacity(0)
            }
            .padding(.top, 20)
            .padding(.bottom, 12)
            .animation(.snappy, value: viewModel.selectedKeywords.isEmpty)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("SORT BY")
                    .bold()
                    .padding(.bottom, 8)

                
                Text("Distance")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                locationStatusLabel
                
                Picker("Distance", selection: $distanceRange) {
                    ForEach(DistanceRange.allCases) { dist in
                        Text(dist.rawValue).tag(dist)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(!locationManager.isAuthorized)
                .opacity(locationManager.isAuthorized ? 1 : 0.5)
                
                Divider()
                
                Text("FEATURES")
                    .bold()
                    .padding(.bottom, 8)

                
                featureRow(title: "Pet Friendly", keyword: "pet friendly")
                featureRow(title: "Fishing", keyword: "fishing")
                featureRow(title: "Lifeguard", keyword: "lifeguard")
                featureRow(title: "Boating", keyword: "boating/jet ski")
                featureRow(title: "Hiking", keyword: "hiking")

                Divider().padding(.vertical, 8)
                
                Button("Apply Filters") { dismiss() }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
            .fontDesign(.rounded)
            
            Spacer()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var locationStatusLabel: some View {
        switch locationManager.authStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            EmptyView()
        case .notDetermined:
            Text("Off")
                .font(.caption)
                .foregroundStyle(.secondary)
        case .denied, .restricted:
            Text("Disabled")
                .font(.caption)
                .foregroundStyle(.red)
        @unknown default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var locationCTA: some View {
        switch locationManager.authStatus {
        case .notDetermined:
            Button {
                locationManager.requestLocation()
            } label: {
                Label("Turn on location to sort by distance", systemImage: "location")
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        case .denied, .restricted:
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label("Enable in Settings", systemImage: "gear")
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func featureRow(title: String, keyword: String) -> some View {
        Button {
            if viewModel.selectedKeywords.contains(keyword) {
                viewModel.selectedKeywords.remove(keyword)
            } else {
                viewModel.selectedKeywords.insert(keyword)
            }
        } label: {
            HStack {
                Image(systemName: viewModel.selectedKeywords.contains(keyword) ? "checkmark.circle.fill" : "circle")
                Text(title)
                    .font(.footnote)
                    .padding(.bottom, 8)
            }
        }
        .buttonStyle(.plain)
    }
}
