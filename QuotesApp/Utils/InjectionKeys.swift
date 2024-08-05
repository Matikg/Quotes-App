//
//  InjectionKeys.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 04/08/2024.
//

import Foundation
import DependencyInjection

// MARK: - NavigationRouter Keys

private struct NavigationRouterKey: InjectionKey {
    static var currentValue: NavigationRouter = NavigationRouter()
}

extension InjectedValues {
    var navigationRouter: NavigationRouter {
        get { Self[NavigationRouterKey.self] }
        set { Self[NavigationRouterKey.self] = newValue }
    }
}
