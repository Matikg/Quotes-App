//
//  RouterInterface.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

protocol RouterInterface: AnyObject, ObservableObject {
    var path: NavigationPath { get set }
    
    func push(route: Route)
    func pop()
    func popAll()
}
