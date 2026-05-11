//
//  LocationOnboardingView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 5/11/26.
//

import SwiftUI

struct LocationOnboardingView: View {
    let onComplete: () -> Void
    
    var body: some View {
        Button("Complete Onboarding") {
            onComplete()
        }
        
    }
}
