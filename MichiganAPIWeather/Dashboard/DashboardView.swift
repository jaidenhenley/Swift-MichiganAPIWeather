//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    @State private var isShowingFilter = false
    @State private var sortByDistance = false
    @State private var distanceRange: DistanceRange = .all
    @FocusState private var isFocused: Bool
    
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack {
            DashboardContentView()
                .blur(radius: viewModel.isSearching ? 10 : 0)
                .animation(.easeInOut, value: viewModel.isSearching)
            
            VStack(spacing: 0) {
                
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Search", text: $viewModel.searchText)
                            .focused($isFocused)
                            .onChange(of: isFocused) { _, focused in
                                if focused {
                                    withAnimation(.easeInOut) {
                                        viewModel.isSearching = true
                                    }
                                }
                            }
                        
                        
                        if viewModel.isSearching {
                            Button("Cancel") {
                                isFocused = false
                                withAnimation {
                                    viewModel.isSearching = false
                                }
                                viewModel.searchText = ""
                                viewModel.selectedKeywords = []
                            }
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .glassEffect()
                    
                    if viewModel.isSearching {
                        HStack(spacing: 12) {
                            if !viewModel.selectedKeywords.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(Array(viewModel.selectedKeywords), id: \.self) { keyword in
                                            Button {
                                                viewModel.selectedKeywords.remove(keyword)
                                            } label: {
                                                HStack(spacing: 4) {
                                                    Text(keyword.capitalized)
                                                        .font(.caption)
                                                        .bold()
                                                        .foregroundStyle(.beachViewText)
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(.ultraThinMaterial)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            } else {
                                Text("No active filters")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                            
                            Button {
                                isShowingFilter = true
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(10)
                                    .background(Color.black.opacity(0.001))
                                    .foregroundStyle(viewModel.selectedKeywords.isEmpty ? AnyShapeStyle(.white) : AnyShapeStyle(Color.blue))
                            }
                            .buttonStyle(.plain)
                            .contentShape(Rectangle())
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding()
                
                if viewModel.isSearching {
                    BeachListView(beachList: viewModel.filteredBeaches, sortByDistance: distanceRange != .all, distanceRange: distanceRange, isFavorites: false)
                        .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .fontDesign(.rounded)
        .sheet(isPresented: $isShowingFilter) {
            FilterCard(distanceRange: $distanceRange, sortByDistance: $sortByDistance)
                .presentationDragIndicator(.visible)
        }
        .animation(.snappy, value: viewModel.selectedKeywords)
        .animation(.easeInOut, value: viewModel.isSearching)
        .onAppear {
            print("[Location] Auth status: \(locationManager.authStatus)")
            locationManager.requestLocation()
            
        }
    }
}
