//
//  FilterCard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/14/26.
//

import SwiftUI

struct FilterCard: View {
    @Environment(BeachViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var sortByDistance = false
    
    var body: some View {
        VStack (spacing:0) {
            
            HStack {
                if !viewModel.selectedKeywords.isEmpty {
                    Button("Clear All") {
                        withAnimation(.snappy) {
                            viewModel.selectedKeywords.removeAll()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                } else {
                    Text("Clear All")
                        .font(.subheadline)
                        .opacity(0)
                }

                Spacer()

                Text("FILTER & SORT")
                    .bold()
                    .fontDesign(.rounded)

                Spacer()

                Text("Clear All")
                    .font(.subheadline)
                    .opacity(0)
            }
            .padding(.top, 20)
            .padding(.bottom, 12)
            .animation(.snappy, value: viewModel.selectedKeywords.isEmpty)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("SORT BY")
                    .bold()
                    .padding(.bottom, 8)

                
                Button {
                    sortByDistance.toggle()
                } label: {
                    HStack {
                        Image(systemName: sortByDistance ? "largecircle.fill.circle" : "circle")
                        Text("Distance")
                    }
                }
                .buttonStyle(.plain)
                
                Divider()
                
                Text("FEATURES")
                    .bold()
                    .padding(.bottom, 8)

                
                featureRow(title: "Pet Friendly", keyword: "pet friendly")
                featureRow(title: "Fishing", keyword: "fishing")
                featureRow(title: "Lifeguard", keyword: "lifeguard")
                featureRow(title: "Boating", keyword: "boating/jet ski")
                featureRow(title: "Hiking", keyword: "hiking")

                Divider().padding(.vertical, 8)
                
                Button("Apply Filters") { dismiss() }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
            .fontDesign(.rounded)
            
            Spacer()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func featureRow(title: String, keyword: String) -> some View {
        Button {
            if viewModel.selectedKeywords.contains(keyword) {
                viewModel.selectedKeywords.remove(keyword)
            } else {
                viewModel.selectedKeywords.insert(keyword)
            }
        } label: {
            HStack {
                Image(systemName: viewModel.selectedKeywords.contains(keyword) ? "checkmark.circle.fill" : "circle")
                Text(title)
                    .font(.footnote)
                    .padding(.bottom, 8)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FilterCard()
        .environment(BeachViewModel())
}
