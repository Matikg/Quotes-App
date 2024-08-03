//
//  InjectionKeyInterface.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation

public protocol InjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}

// Injection key for NavigationRouter
struct NavigationRouterKey: InjectionKey {
    static var currentValue: any NavigationRouting = NavigationRouter()
}
