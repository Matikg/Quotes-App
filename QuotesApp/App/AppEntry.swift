//
//  QuotesAppApp.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/07/2024.
//

import SwiftUI
import DependencyInjection

@main
struct AppEntry: App {
    @StateObject private var navigationRouter = InjectedValues[\.navigationRouter]
    @StateObject private var rootScreenViewModel = RootScreenViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(
                path: Binding(
                    get: {
                        self.navigationRouter.path
                    },
                    set: {
                        self.navigationRouter.set(navigationStack: $0)
                    }
                )
            ) {
                RootScreenView(viewModel: rootScreenViewModel)
                    .navigationDestination(for: Route.self, destination: { $0 })
            }
        }
    }
}
