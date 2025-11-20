//
//  SplashScreenView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    
    @State private var iconScale: CGFloat = 0.6
    @State private var iconOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("icon_bitcoin_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                
                Text("CryptoTracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            // A sequence of animations for a professional launch experience.
            
            // 1. Animate the icon first.
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            
            // 2. Animate the text with a slight delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.8)) {
                    textOpacity = 1.0
                }
            }
            
            // 3. Schedule the transition to the main app.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isActive = false
            }
        }
    }
}
