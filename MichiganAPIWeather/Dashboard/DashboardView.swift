//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(BeachViewModel.self) var viewModel
    
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ZStack {
                // Your main dashboard content
                DashboardContentView()
                    .blur(radius: viewModel.isSearching ? 10 : 0)
                    .animation(.easeInOut, value: viewModel.isSearching)
                
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search", text: $viewModel.searchText)
                        
                        if viewModel.isSearching {
                            Button("Cancel") {
                                withAnimation(.easeInOut) {
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
                    .padding(.horizontal)
                    
                    if viewModel.isSearching {
                        BeachListView()
                            .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
