//
//  QuotesAppApp.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI

@main
struct QuotesAppApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                WelcomeScreen(isFirstLaunch: $isFirstLaunch)
                    .globalBackground()
                
            } else {
                MainScreen()
                    .globalBackground()
            }
        }
    }
}
