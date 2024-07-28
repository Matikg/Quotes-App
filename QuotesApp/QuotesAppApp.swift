//
//  QuotesAppApp.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI

@main
struct QuotesAppApp: App {
    @StateObject var routerManager = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                RootScreenView(viewModel: RootScreenViewModel())
                    .navigationDestination(for: Route.self, destination: { $0 })
            }
        }
    }
}
