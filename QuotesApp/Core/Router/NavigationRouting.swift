//
//  RouterInterface.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

protocol NavigationRouting: AnyObject, ObservableObject {
    var path: NavigationPath { get set }
    var presentedSheet: Route? { get set }
    
    func push(route: Route)
    func pop()
    func popAll()
    func set(navigationStack: NavigationPath)
    func present(sheet: Route)
}
