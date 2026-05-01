//
//  NotficationSheet.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/28/26.
//

import Foundation
import SwiftUI

struct NotificationSheet: View {
    @Binding var showingAlertSheet: Bool
    @Binding var alertTimeInterval: Double

    @AppStorage("notifyDailyTop") private var notifyDailyTop: Bool = true
    @AppStorage("notifyThreshold") private var notifyThreshold: Bool = true
    @AppStorage("notifySevere") private var notifySevere: Bool = true

    private var alertTimeBinding: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: alertTimeInterval) },
            set: { alertTimeInterval = $0.timeIntervalSince1970 }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications")
                .font(.title)
                .bold()
                .padding(.top, 80)
            
            Text("Recieve notifications about updates for your beach.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            Toggle("\(Image(systemName: "beach.umbrella"))  Daily Top Beach", isOn: $notifyDailyTop)
                .font(.headline)
            if notifyDailyTop {
                DatePicker("Alert Time", selection: alertTimeBinding, displayedComponents: .hourAndMinute)
                    .padding(.leading, 40)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
                .padding(.vertical, 8)

            Toggle("\(Image(systemName: "star"))  Great Conditions Alert", isOn: $notifyThreshold)
                .font(.headline)
            
            Divider()
                .padding(.vertical, 8)
            Toggle("\(Image(systemName: "cloud.heavyrain"))  Severe Weather Warning", isOn: $notifySevere)
                .font(.headline)
            

            Divider()
            Spacer()

            Button("Done") {
                showingAlertSheet = false
            }
            .font(.footnote)
            .foregroundStyle(.blueGreen)
            .fontWeight(.bold)
            .padding(.horizontal, 50)
            .padding(.vertical, 16)
            .background(Color.yellow)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.blueGreen, lineWidth: 1))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 27)
    }
}
