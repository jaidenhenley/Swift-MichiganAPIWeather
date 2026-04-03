//
//  TopOfPageBeachInformation.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/2/26.
//

import SwiftUI

struct TopOfPageBeachInformation: View {
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Text("image of beach")
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 230, height: 230).foregroundColor(.gray.opacity(0.2))
            }
            
                VStack(spacing: 5) {
                    ZStack {
                        VStack{
                            Text("AIR TEMP")
                                .font(.caption)
                            Text("70°").font(.largeTitle)
                                .bold()

                        }
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 110, height: 110)
                        .foregroundColor(.gray.opacity(0.2))
                }
                ZStack {
                    VStack {
                        Text("WATER TEMP")
                            .font(.caption)
                        Text("52°")
                            .font(.largeTitle)
                            .bold()
                    }
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 110, height: 110)
                        .foregroundColor(.gray.opacity(0.2))
                }
            }
        }
    }
}

#Preview {
    TopOfPageBeachInformation()
}
