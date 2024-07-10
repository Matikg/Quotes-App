//
//  WelcomeScreen.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 09/07/2024.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack {
            
            // Image
            Image("book-image")
            
            // Title
            Text("Book Quote Saver")
                .font(.system(size: 32))
                .bold()
                .padding(.bottom)
            
            // Subtitle
            Text("Capture wisdom, fuel your growth.")
                .font(.system(size: 18))
            
            // Divider
            Rectangle()
                .frame(height: 1)
                .padding()
            
            // Details
            VStack(spacing: 30) {
                Text("QuoteScan turns your camera into a \npowerful tool for personal development.")
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("· Scan and save inspiring quotes")
                    Text("· Organize your personal growth journey")
                    Text("· Transform reading into actionable\n  wisdom")
                }
            }
            
            Spacer()
            
            Text("Ready to start your collection of life-changing ideas?")
                .font(.system(size: 16))
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            // CTA Button
            CustomButton(label: "Let's go!", action: {
                isFirstLaunch = false
            })
            .padding(.top)
        }
        .foregroundStyle(Color.accentColor)
        .padding()
    }
}

#Preview {
    WelcomeScreen(isFirstLaunch: .constant(true))
}
