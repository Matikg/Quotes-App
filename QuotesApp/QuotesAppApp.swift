//
//  QuotesAppApp.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI

@main
struct QuotesAppApp: App {
    @AppStorage(UserDefaultsConstants.FirstLaunchKey) var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                WelcomeScreenView(viewModel: WelcomeScreenViewModel())
                    .globalBackground()
            }
            else {
                MainScreenView()
                    .globalBackground()
            }
        }
    }
}
