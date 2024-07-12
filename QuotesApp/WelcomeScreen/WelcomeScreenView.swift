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
        VStack {
            Image(.book)
            
            Text(String(localized: "title"))
                .font(.system(size: 32))
                .bold()
                .padding(.bottom)
            
            Text(String(localized: "subtitle"))
                .font(.system(size: 18))
            
            CustomDivider()
            
            buildDescriptionView()
            
            Spacer()
            
            Text(String(localized: "cta"))
                .font(.system(size: 16))
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            CustomButton(label: "Let's go!", action: {
                viewModel.ctaButtonTapped()
            })
            .padding(.top)
        }
        .foregroundStyle(Color.accentColor)
        .padding()
    }
    
    private func buildDescriptionView() -> some View {
        VStack(spacing: 30) {
            Text(String(localized: "description"))
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                Text(String(localized: "detail1"))
                Text(String(localized: "detail2"))
                Text(String(localized: "detail3"))
            }
        }
    }
    
}

#Preview {
    WelcomeScreenView(viewModel: WelcomeScreenViewModel())
}
