//
//  QuotesAppApp.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI

@main
struct QuotesAppApp: App {
    @Injected(\.navigationRouter) private var navigationRouter: any NavigationRouting
    //    @StateObject private var navigationRouter = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationRouter.path) {
                RootScreenView(viewModel: RootScreenViewModel())
                    .navigationDestination(for: Route.self, destination: { $0 })
            }
        }
    }
}
