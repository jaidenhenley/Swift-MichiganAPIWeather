//
//  CrowdMeterView.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct CrowdMeterView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "person.3.fill")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
                Text("CROWD METER")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
                    .padding(.vertical)
                Spacer()
            }
            
            .padding(.horizontal, 40)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<8, id: \.self) { _ in
                Rectangle()
                        .fill(Color.blue)
                        .frame(width: 35, height: CGFloat.random(in: 40 ... 100))
                }
            }
            
            
            HStack {
                Text("8am")
                Spacer()
                Text("12pm")
                Spacer()
                Text("8pm")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    CrowdMeterView()
}
