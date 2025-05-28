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
        container.register(CoreDataManagerInterface.self, instance: CoreDataManager())
        container.register(BookApiService.self, instance: BookApiService())
        container.register(SaveQuoteRepositoryInterface.self, instance: SaveQuoteRepository())
        container.register(SaveScannedQuoteRepositoryInterface.self, instance: SaveScannedQuoteRepository())
        container.register(CrashlyticsManagerInterface.self, instance: CrashlyticsManager())
        container.register(PurchaseManagerInterface.self, instance: PurchaseManager())
        container.register(CameraAccessManagerInterface.self, instance: CameraAccessManager())
    }
}

enum FeatureName: String {
    case `default`
}
