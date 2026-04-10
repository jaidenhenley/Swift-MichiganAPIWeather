//
//  MapView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/9/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var mapVM = MapViewModel()
    @State private var selectedBeach: BeachViewModel.ViewBeach? = nil
    @State private var showDetail = false

    var visibleBeaches: [BeachViewModel.ViewBeach] {
        mapVM.beaches.filter { beach in
            mapVM.region.contains(coordinate: beach.beachCoordinates)
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $mapVM.region,
                annotationItems: mapVM.beaches) { beach in

                MapAnnotation(coordinate: beach.beachCoordinates) {
                    Button {
                        selectedBeach = beach
                        showDetail = true
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(selectedBeach?.id == beach.id ? .orange : .blue)
                                    .frame(width: 36, height: 36)
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                            }
                            .shadow(radius: 4)

                            Text(beach.beachName)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 80)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 4))
                        }
                    }
                }
            }
            .ignoresSafeArea()

            if !visibleBeaches.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(visibleBeaches) { beach in
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
        .sheet(isPresented: $showDetail) {
            if let beach = selectedBeach {
                BeachView(beach: beach, beachID: beach.beachID)
            }
        }
    }
}


extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let latOK = abs(coordinate.latitude - center.latitude) <= span.latitudeDelta / 2
        let lonOK = abs(coordinate.longitude - center.longitude) <= span.longitudeDelta / 2
        return latOK && lonOK
    }
}



#Preview {
    MapView()
}
