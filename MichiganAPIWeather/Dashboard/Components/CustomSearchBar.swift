//
//  CustomSearchBar.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/2/26.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .imageScale(.small)
                
                TextField("Search...", text: $text)
                    .focused($isFocused)
                    .onChange(of: isFocused) { _, focused in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isEditing = focused
                        }
                    }
                
                if isEditing && !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundStyle(.secondary)
                            .imageScale(.small)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassEffect(.regular.interactive())
                if isEditing {
                    Button("Cancel") {
                        text = ""
                        isFocused = false
                    }
                    .foregroundStyle(.primary)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .padding(.trailing, 16)
                }
        }
    }
}
