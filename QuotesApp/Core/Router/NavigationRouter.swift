//
//  NavigationRouter.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

final class NavigationRouter: ObservableObject, NavigationRouting {
    @Published var path = NavigationPath()
    
    func push(route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popAll() {
        path = NavigationPath()
    }
    
    func set(navigationStack: NavigationPath) {
        path = navigationStack
    }
}
