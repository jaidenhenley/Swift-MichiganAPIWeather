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
    @Binding var sortByDistance: Bool
    var body: some View {
        @Bindable var viewModel = viewModel  

        VStack(spacing: 0) {
            
            // Header
            HStack {
                if !viewModel.selectedKeywords.isEmpty || viewModel.filterSwimmable || sortByDistance {
                    Button("Clear All") {
                        withAnimation(.snappy) {
                            viewModel.selectedKeywords.removeAll()
                            viewModel.filterSwimmable = false
                            sortByDistance = false
                            distanceRange = .all
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    Text("Clear All").font(.subheadline).opacity(0)
                }

                Spacer()
                Text("FILTER & SORT").bold().fontDesign(.rounded)
                Spacer()
                Text("Clear All").font(.subheadline).opacity(0)
            }
            .padding(.top, 20)
            .padding(.bottom, 12)
            .animation(.snappy, value: viewModel.selectedKeywords.isEmpty)

            Divider()

            VStack(alignment: .leading, spacing: 0) {
                
                // Sort
                Text("SORT BY")
                    .bold()
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                toggleRow(title: "Nearest to me", isOn: $sortByDistance)
                
                if sortByDistance {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Within")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            locationStatusLabel
                        }
                        
                        Picker("Distance", selection: $distanceRange) {
                            ForEach(DistanceRange.allCases) { dist in
                                Text(dist.rawValue).tag(dist)
                            }
                        }
                        .pickerStyle(.segmented)
                        .disabled(!locationManager.isAuthorized)
                        .opacity(locationManager.isAuthorized ? 1 : 0.5)
                        
                        if !locationManager.isAuthorized {
                            locationCTA
                        }
                    }
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Divider().padding(.vertical, 12)

                // Park Type
                Text("PARK TYPE")
                    .bold()
                    .padding(.bottom, 8)

                keywordRow(title: "State Park", keyword: "state park")
                keywordRow(title: "National Park", keyword: "national park")
                keywordRow(title: "City Beach", keyword: "city beach")
                keywordRow(title: "County Park", keyword: "county park")

                Divider().padding(.vertical, 12)

                // Activities
                Text("ACTIVITIES")
                    .bold()
                    .padding(.bottom, 8)

                keywordRow(title: "Hiking", keyword: "hiking")
                keywordRow(title: "Fishing", keyword: "fishing")
                keywordRow(title: "Kayaking", keyword: "kayaking")
                keywordRow(title: "Bird Watching", keyword: "bird watching")
                keywordRow(title: "Rock Hunting", keyword: "rock hunting")
                keywordRow(title: "Dark Sky / Stargazing", keyword: "dark sky")

                Divider().padding(.vertical, 12)

                // Amenities
                Text("AMENITIES")
                    .bold()
                    .padding(.bottom, 8)

                keywordRow(title: "Camping available", keyword: "camping")
                toggleRow(title: "Swimmable beach", isOn: $viewModel.filterSwimmable)

                Divider().padding(.vertical, 12)

                Button("Apply Filters") { dismiss() }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.bottom, 8)
            }
            .fontDesign(.rounded)

            Spacer()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var locationStatusLabel: some View {
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
    var locationCTA: some View {
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
                Text("Enable Location")
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func keywordRow(title: String, keyword: String) -> some View {
        Button {
            if viewModel.selectedKeywords.contains(keyword) {
                viewModel.selectedKeywords.remove(keyword)
            } else {
                viewModel.selectedKeywords.insert(keyword)
            }
        } label: {
            HStack {
                Image(systemName: viewModel.selectedKeywords.contains(keyword) ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(viewModel.selectedKeywords.contains(keyword) ? .blue : .secondary)
                Text(title)
                    .font(.footnote)
                Spacer()
            }
            .padding(.bottom, 8)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func toggleRow(title: String, isOn: Binding<Bool>) -> some View {
        Button {
            withAnimation(.snappy) { isOn.wrappedValue.toggle() }
        } label: {
            HStack {
                Image(systemName: isOn.wrappedValue ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isOn.wrappedValue ? .blue : .secondary)
                Text(title)
                    .font(.footnote)
                Spacer()
            }
            .padding(.bottom, 8)
        }
        .buttonStyle(.plain)
    }
}
