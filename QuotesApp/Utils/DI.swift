//
//  DI.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 08/02/2025.
//

import Foundation
import DependencyInjection

extension ContainerManager {
    func registerDefaults() {
        let container = container(for: .main)
        container.register(CoreDataManagerProtocol.self, instance: CoreDataManager())
        container.register(BookApiService.self, instance: BookApiService())
    }
}

enum FeatureName: String {
    case addQuote
}
