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
                
                QText("WelcomeScreen_title", type: .bold, size: .large)
                    .padding(.bottom)
                
                QText("WelcomeScreen_subtitle", type: .regular, size: .medium)
                
                CustomDivider()
                
                buildDescriptionView()
                
                Spacer()
                
                QText("WelcomeScreen_cta", type: .bold, size: .small)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
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
            QText("WelcomeScreen_description", type: .regular, size: .small)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                QText("WelcomeScreen_detail1", type: .regular, size: .small)
                QText("WelcomeScreen_detail2", type: .regular, size: .small)
                QText("WelcomeScreen_detail3", type: .regular, size: .small)
            }
        }
    }
}

#Preview {
    WelcomeScreenView(viewModel: WelcomeScreenViewModel())
}
