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
    
    @Environment(LocationManager.self) var locationManager
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.0, longitude: -85.5),
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        )
    )

    var body: some View {
        ZStack(alignment: .bottom) {
            
            Map(position: $position) {
                if mapVM.isZoomedOut {
                    let clusters = mapVM.makeClusters()
                    
                    ForEach(clusters) { cluster in
                        Annotation("", coordinate: cluster.coordinate) {
                            clusterView(cluster)
                        }
                    }
                    
                } else {
                    ForEach(mapVM.filteredBeaches) { beach in
                        Annotation(beach.beachName, coordinate: beach.coordinates) {
                            beachAnnotation(beach)
                        }
                    }
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                mapVM.updateVisibleBeaches(in: context.region)
            }
            .ignoresSafeArea()

            beachListOverlay
        }
        .task {
            locationManager.requestLocation()
        }
        .sheet(isPresented: $showDetail) {
            if let beach = selectedBeach {
                BeachView(beach: beach, beachID: beach.id)
            }
        }
    }

    private func clusterView(_ cluster: BeachCluster) -> some View {
        Button {
            withAnimation(.easeInOut) {
                position = .region(
                    MKCoordinateRegion(
                        center: cluster.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                    )
                )
            }
        } label: {
            ZStack {
                Circle()
                    .fill(.orange)
                    .frame(width: 44, height: 44)
                
                Text("\(cluster.beaches.count)")
                    .foregroundStyle(.white)
                    .font(.headline)
            }
            .shadow(radius: 5)
        }
        .accessibilityLabel("\(cluster.beaches.count) beaches in this area")
        .accessibilityHint("Double tap to zoom in")
    }

    private func beachAnnotation(_ beach: Beach) -> some View {
        Button {
            selectedBeach = beach
            showDetail = true
        } label: {
            ZStack {
                Circle()
                    .fill(.mapBlueGreen)
                
                Image(systemName: "beach.umbrella.fill")
                    .font(.system(size: 24))  
                    .foregroundStyle(.mapYellow)
            }
            .frame(width: 44, height: 44)
            .shadow(radius: 4)
            
        }
        .accessibilityLabel(beach.beachName)
           .accessibilityHint("Double tap to view beach details")
    }

    private var beachListOverlay: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(mapVM.filteredBeaches) { beach in
                    MapViewCard(
                        beach: beach,
                        isSelected: selectedBeach?.id == beach.id,
                        userLocation: locationManager.userLocation
                    )
                    .onTapGesture {
                        selectedBeach = beach
                        showDetail = true
                    }
                    .accessibilityLabel(beach.beachName)
                    .accessibilityHint("Double tap to view beach details")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(.ultraThinMaterial)
        .accessibilityLabel("Nearby beaches")
    }
}

#Preview {
    MapView()
}
