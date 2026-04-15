//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(BeachViewModel.self) var viewModel
    @State private var isShowingFilter = false

    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            ZStack {
                // 1. Background Content
                DashboardContentView()
                    .blur(radius: viewModel.isSearching ? 10 : 0)
                    .animation(.easeInOut, value: viewModel.isSearching)
                
                // 2. Foreground UI
                VStack(spacing: 0) {
                    
                    // SEARCH & FILTER SECTION
                    VStack(spacing: 8) {
                        // The Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            
                            TextField("Search", text: $viewModel.searchText, onEditingChanged: { editing in
                                withAnimation(.easeInOut) {
                                    viewModel.isSearching = editing
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
                        
                        // FILTER CHIPS SECTION (Only visible when searching)
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
                                        .foregroundStyle(viewModel.selectedKeywords.isEmpty ? AnyShapeStyle(.primary) : AnyShapeStyle(Color.blue))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding() // Padding around the whole search/filter area
                    
                    // RESULTS SECTION
                    if viewModel.isSearching {
                        BeachListView()
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
    }
}
