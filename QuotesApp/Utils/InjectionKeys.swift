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

// MARK: - CoreDataManager Keys

private struct CoreDataManagerKey: InjectionKey {
    static var currentValue: CoreDataManagerProtocol = CoreDataManager()
}

extension InjectedValues {
    var coreDataManager: CoreDataManagerProtocol {
        get { Self[CoreDataManagerKey.self] }
        set { Self[CoreDataManagerKey.self] = newValue }
    }
}

// MARK: - ApiService Keys

private struct ApiServiceKey: InjectionKey {
    static var currentValue: ApiService = ApiService()
}

extension InjectedValues {
    var apiService: ApiService {
        get { Self[ApiServiceKey.self] }
        set { Self[ApiServiceKey.self] = newValue }
    }
}
