//
//  InjectedValues.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation

struct InjectedValues {
    private static var current = InjectedValues()
    
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

// Injection key path for NavigationRouter
extension InjectedValues {
    var navigationRouter: any NavigationRouting {
        get { Self[NavigationRouterKey.self] }
        set { Self[NavigationRouterKey.self] = newValue }
    }
}
