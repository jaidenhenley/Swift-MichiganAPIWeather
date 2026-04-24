//
//  BeachHoursCard.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import SwiftUI

struct BeachHoursCard: View {
    var body: some View {
        
        VStack {
            Text("BEACH HOURS")
            HStack {
                Image("")
                DayAndHours(dayOfWeek: "S", beachHours: "8am-10pm")
                DayAndHours(dayOfWeek: "M", beachHours: "8am-10pm")
                DayAndHours(dayOfWeek: "T", beachHours: "8am-10pm")
                DayAndHours(dayOfWeek: "W", beachHours: "8am-10pm")
                DayAndHours(dayOfWeek: "T", beachHours: "8am-10pm")
                DayAndHours(dayOfWeek: "F", beachHours: "8am-10pm")
                DayAndHours(dayOfWeek: "S", beachHours: "8am-10pm")

            }
        }
    }
}

#Preview {
    BeachHoursCard()
}

struct DayAndHours: View {
    
    let dayOfWeek: String
    let beachHours: String
    
    var body: some View {
        HStack {
            Text(dayOfWeek)
            Text(beachHours)
        }
    }
}
