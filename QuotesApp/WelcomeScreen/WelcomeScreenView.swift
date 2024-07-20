//
//  WelcomeScreen.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 09/07/2024.
//

import SwiftUI

struct WelcomeScreenView: View {
    @ObservedObject var viewModel: WelcomeScreenViewModel
    
    var body: some View {
        BackgroundStack {
            VStack {
                Image(.book)
                
                Text(String(localized: "WelcomeScreen_title"))
                    .font(.system(size: 32))
                    .bold()
                    .padding(.bottom)
                
                Text(String(localized: "WelcomeScreen_subtitle"))
                    .font(.system(size: 18))
                
                CustomDivider()
                
                buildDescriptionView()
                
                Spacer()
                
                Text(String(localized: "WelcomeScreen_cta"))
                    .font(.system(size: 16))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                CustomButton(label: "Let's go!", action: {
                    viewModel.ctaButtonTapped()
                })
            }
            .foregroundStyle(Color.accentColor)
            .padding()
        }
    }
    
    private func buildDescriptionView() -> some View {
        VStack(spacing: 30) {
            Text(String(localized: "WelcomeScreen_description"))
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                Text(String(localized: "WelcomeScreen_detail1"))
                Text(String(localized: "WelcomeScreen_detail2"))
                Text(String(localized: "WelcomeScreen_detail3"))
            }
        }
    }
}

#Preview {
    WelcomeScreenView(viewModel: WelcomeScreenViewModel())
}
