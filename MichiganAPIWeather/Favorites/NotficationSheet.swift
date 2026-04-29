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
        VStack(alignment: .leading, spacing: 20) {
            Text("Beach Alerts")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            Divider()

            Toggle("Daily top beach", isOn: $notifyDailyTop)
            if notifyDailyTop {
                DatePicker("Alert time", selection: alertTimeBinding, displayedComponents: .hourAndMinute)
                    .padding(.leading, 16)
            }

            Toggle("Great conditions alert", isOn: $notifyThreshold)
            Toggle("Severe weather warning", isOn: $notifySevere)

            Divider()

            Button("Done") {
                showingAlertSheet = false
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
