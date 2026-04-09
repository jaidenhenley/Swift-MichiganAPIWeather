//
//  DashboardView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/9/26.
//

import SwiftUI

struct DashboardView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                // Your main dashboard content
                DashboardContentView(searchText: $searchText)
                    .blur(radius: isSearching ? 10 : 0)
                    .animation(.easeInOut, value: isSearching)
                
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search", text: $searchText, onEditingChanged: { editing in
                            withAnimation(.easeInOut) {
                                isSearching = editing
                            }
                        })
                        
                        if isSearching {
                            Button("Cancel") {
                                withAnimation(.easeInOut) {
                                    isSearching = false
                                    searchText = ""
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .glassEffect()
                    .padding(.horizontal)
                    
                    if isSearching {
                        BeachListView(query: $searchText)
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
