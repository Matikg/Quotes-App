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
                RootScreenView(viewModel: RootScreenViewModel())
                    .navigationDestination(for: Route.self, destination: { $0 })
            }
        }
    }
}
