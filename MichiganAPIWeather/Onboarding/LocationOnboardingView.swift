//
//  LocationOnboardingView.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 5/11/26.
//

import SwiftUI

struct LocationOnboardingView: View {
    let gradient1 = Color(hex: "E5EFF4")
    let gradient2 = Color(hex: "C7DBE6")
    let subtitleColor = Color(hex: "585858")
    
    let button1 = Color(hex: "0097A3")
    let button2 = Color(hex: "005E6A")
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
                           .foregroundStyle(.white)
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
               Image(.coastCastHeadline)
               Spacer()
               Image(.onboarding1)
                   .resizable()
                   .scaledToFit()
               Text("Discover,\nExplore, Relax")
                   .foregroundStyle(.customWhite)
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
           }
       }

       var pageTwo: some View {
           VStack {
               Image(.coastCastHeadline)
               Spacer()
               Image(.onboarding2)
                   .resizable()
                   .scaledToFit()
               Text("Perfect Weather.\nPerfect Waves.")
                   .foregroundStyle(.customWhite)
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
           }
       }

       var pageThree: some View {
           VStack {
               Image(.coastCastHeadline)
               Spacer()
               Image(.onboarding3)
                   .resizable()
                   .scaledToFit()
               Text("Explore Endless\nSummer")
                   .foregroundStyle(.customWhite)
                   .font(.system(size: 42))
                   .fontDesign(.rounded)
                   .bold()
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 10)
               Text("Find new beaches, chase sunny skies,\nand create your next coastal\nadventure")
                   .foregroundStyle(subtitleColor)
                   .multilineTextAlignment(.center)
                   .font(.headline)
                   .fontDesign(.rounded)
                   .fontWeight(.semibold)
           }
       }
}
