//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

import SwiftUI

struct DashboardView: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(LocationManager.self) var locationManager
    @State private var isShowingFilter = false

    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            ZStack {
                DashboardContentView()
                    .blur(radius: viewModel.isSearching ? 10 : 0)
                    .animation(.easeInOut, value: viewModel.isSearching)
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            
                            TextField("Search", text: $viewModel.searchText, onEditingChanged: { editing in
                                withAnimation(.easeInOut) {
                                    viewModel.isSearching = true
                                }
                            })
                            
                            if viewModel.isSearching {
                                Button("Cancel") {
                                    withAnimation(.easeInOut) {
                                        viewModel.isSearching = false
                                        viewModel.searchText = ""
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
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
                                                HStack(spacing: 4) {
                                                    Text(keyword.capitalized)
                                                        .font(.caption)
                                                        .bold()
                                                    
                                                    Button {
                                                        viewModel.selectedKeywords.remove(keyword)
                                                    } label: {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .font(.caption)
                                                    }
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(.ultraThinMaterial)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                        }
                                    }
                                } else {
                                    Text("No active filters")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
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
                                        .foregroundStyle(viewModel.selectedKeywords.isEmpty ? AnyShapeStyle(.primary) : AnyShapeStyle(Color.blue))
                                }
                                .buttonStyle(.plain)
                                .contentShape(Rectangle())
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding()
                    
                    if viewModel.isSearching {
                        BeachListView(beachList: viewModel.filteredBeaches)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
            .fontDesign(.rounded)
            .sheet(isPresented: $isShowingFilter) {
                FilterCard()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .animation(.snappy, value: viewModel.selectedKeywords)
            .animation(.easeInOut, value: viewModel.isSearching)
        }
        .onAppear {
            print("[Location] Auth status: \(locationManager.authStatus)")
            locationManager.requestLocation()
        }
    }
}
