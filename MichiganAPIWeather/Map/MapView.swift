//
//  MapView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import SwiftUI
import MapKit


struct MapView: View {
    @State private var mapVM = MapViewModel()
    @State private var selectedBeach: Beach? = nil
    @State private var showDetail = false
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position) {
                ForEach(mapVM.filteredBeaches) { beach in
                    Annotation(beach.beachName, coordinate: beach.coordinates) {
                        beachAnnotation(beach)
                    }
                }
            }
            .onMapCameraChange { context in
                // This triggers the filtering as you zoom in/out
                mapVM.updateVisibleBeaches(in: context.region)
            }
            .ignoresSafeArea()

            beachListOverlay
        }
        .sheet(isPresented: $showDetail) {
            if let beach = selectedBeach {
                BeachView(beach: beach, beachID: beach.id)
            }
        }
    }

    // Helper to keep the Map builder clean
    private func beachAnnotation(_ beach: Beach) -> some View {
        Button {
            selectedBeach = beach
            showDetail = true
        } label: {
            ZStack {
                Circle()
                    .fill(selectedBeach?.id == beach.id ? .orange : .blue)
                    .frame(width: 36, height: 36)
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
            .shadow(radius: 4)
        }
    }

    // Helper to keep the ZStack clean
    private var beachListOverlay: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(mapVM.filteredBeaches) { beach in
                    BeachPreviewCard(beach: beach, isSelected: selectedBeach?.id == beach.id)
                        .onTapGesture {
                            selectedBeach = beach
                            showDetail = true
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    MapView()
}
