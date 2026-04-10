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
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.0, longitude: -85.5),
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        )
    )

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position) {
                ForEach(mapVM.beaches) { beach in
                    Annotation(beach.beachName, coordinate: beach.coordinates) {
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
                }
            }
            .ignoresSafeArea()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(mapVM.beaches) { beach in
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
        .sheet(isPresented: $showDetail) {
            if let beach = selectedBeach {
                BeachView(beach: beach, beachID: beach.id)
            }
        }
    }
}


#Preview {
    MapView()
}
