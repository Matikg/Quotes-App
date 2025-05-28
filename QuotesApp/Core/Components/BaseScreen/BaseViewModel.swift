//
//  BaseViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 26/05/2025.
//

import Foundation
import DependencyInjection

class BaseViewModel: ObservableObject {
    @Injected var navigationRouter: any NavigationRouting
    
    var showBackButton: Bool {
        !navigationRouter.path.isEmpty
    }
    
    func navigateBack() {
        navigationRouter.pop()
    }
}
