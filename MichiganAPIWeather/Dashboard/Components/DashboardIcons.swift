//
//  DashboardIcons.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/8/26.
//

import SwiftUI

struct DashboardCategory: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
}

struct DashboardIcons: View {
    var icon: String
    var title: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.blueGreen, lineWidth: 2)
                    .frame(width: 62, height: 62)
                
                if icon == "familyIcon" {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.blueGreen)
                } else if icon == "familyIconWhite" {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.blueGreen)
                } else {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(.blueGreen)
                }
            }
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    DashboardIcons(icon: "sun.min", title: "Hot Weather")
}
