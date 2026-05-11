//
//  LocationOnboardingView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 5/11/26.
//

import SwiftUI

struct LocationOnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    var isDark: Bool { colorScheme == .dark }

    var gradient1: Color { isDark ? Color(hex: "005E6A") : Color(hex: "E5EFF4") }
    var gradient2: Color { isDark ? Color(hex: "182C37") : Color(hex: "C7DBE6") }
    var subtitleColor: Color { isDark ? Color(hex: "CCCCCC") : Color(hex: "585858")}
    
    var button1: Color { isDark ? Color(hex: "C7DBE6") : Color(hex: "0097A3") }
    var button2: Color { isDark ? Color(hex: "EFCA08") : Color(hex: "005E6A") }
    
    @State private var currentPage = 0

    
    let onComplete: () -> Void
    
    var body: some View {
           ZStack {
               LinearGradient(colors: [gradient1, gradient2], startPoint: .leading, endPoint: .trailing)
                   .ignoresSafeArea()

               VStack {

                   TabView(selection: $currentPage) {
                       pageOne.tag(0)
                       pageTwo.tag(1)
                       pageThree.tag(2)
                   }
                   .tabViewStyle(.page(indexDisplayMode: .never))

                   HStack(spacing: 8) {
                       ForEach(0..<3, id: \.self) { index in
                           Capsule()
                               .fill(currentPage == index ? Color.black : Color.black.opacity(0.3))
                               .frame(width: currentPage == index ? 20 : 8, height: 8)
                               .animation(.spring(), value: currentPage)
                       }
                   }
                   .padding(.horizontal, 12)
                   .padding(.vertical, 8)
                   .background(.white.opacity(0.9), in: Capsule())
                   .padding(.bottom, 8)
                   
                   Button {
                       if currentPage < 2 {
                           withAnimation { currentPage += 1 }
                       } else {
                           onComplete()
                       }
                   } label: {
                       Text(currentPage < 2 ? "Next" : "Get Started")
                           .frame(maxWidth: .infinity)
                           .padding(.vertical, 24)
                           .background(LinearGradient(colors: [button1, button2], startPoint: .leading, endPoint: .trailing))
                           .foregroundStyle(isDark ? .black : .white)
                           .clipShape(RoundedRectangle(cornerRadius: 14))
                           .font(.subheadline)
                           .fontWeight(.semibold)
                   }
                   .padding(.horizontal, 24)
                   .padding(.bottom, 12)
               }
           }
        }

       var pageOne: some View {
           VStack {
               Image(isDark ? .coastCastHeadlineLight : .coastCastHeadline)
               Spacer()
               Image(.onboarding1)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 341, height: 336)
               Text("Discover,\nExplore, Relax")
                   .foregroundStyle(.customBlack)
                   .font(.system(size: 42))
                   .fontDesign(.rounded)
                   .bold()
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 10)
               Text("Let us help you discover the best\nbeaches, track conditions, and\nplan the perfect day")
                   .foregroundStyle(subtitleColor)
                   .multilineTextAlignment(.center)
                   .font(.headline)
                   .fontDesign(.rounded)
                   .fontWeight(.semibold)
               Spacer()

           }
       }

       var pageTwo: some View {
           VStack {
               Image(isDark ? .coastCastHeadlineLight : .coastCastHeadline)
               Spacer()
               Image(isDark ? .onboarding2Dark : .onboarding2)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 338, height: 325)
               Spacer()
               Text("Perfect Weather.\nPerfect Waves.")
                   .foregroundStyle(.customBlack)
                   .font(.system(size: 42))
                   .fontDesign(.rounded)
                   .bold()
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 10)
               Text("Let us help you discover the best\nbeaches, track conditions, and\nplan the perfect day")
                   .foregroundStyle(subtitleColor)
                   .multilineTextAlignment(.center)
                   .font(.headline)
                   .fontDesign(.rounded)
                   .fontWeight(.semibold)
               Spacer()

           }
       }

       var pageThree: some View {
           VStack {
               Image(isDark ? .coastCastHeadlineLight : .coastCastHeadline)
               Spacer()
               Image(.onboarding3)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 322, height: 321)
               Spacer()
               Text("Explore Endless\nSummer")
                   .foregroundStyle(.customBlack)
                   .font(.system(size: 42))
                   .fontDesign(.rounded)
                   .bold()
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 10)
               Text("CoastCast uses your location to\noptimize how you find new beaches,\nchase sunny skies, and create your\nnext coastal adventure.")
                   .foregroundStyle(subtitleColor)
                   .multilineTextAlignment(.center)
                   .font(.headline)
                   .fontDesign(.rounded)
                   .fontWeight(.semibold)
               Spacer()

           }
       }
}
