//
//  PurchaseManager.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 18/05/2025.
//

import Foundation
import RevenueCat
import DependencyInjection

protocol PurchaseManagerInterface {
    func checkPremiumAction() async -> Bool
}

final class PurchaseManager: PurchaseManagerInterface {
    @Injected private var coreDataManager: CoreDataManagerInterface
    
    private enum Configuration {
        static let quoteLimit = 3
    }
    
    init() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(withAPIKey: Constants.paywallConfigurationKey)
    }
    
    func checkPremiumAction() async -> Bool {
        let hasPremium = await checkFullAccess()
        let quotesCount = coreDataManager.fetchAllQuotes().count
        
        return hasPremium || quotesCount < Configuration.quoteLimit
    }
    
    private func checkFullAccess() async -> Bool {
        let customerInfo = try? await Purchases.shared.customerInfo()
        return customerInfo?.entitlements[Constants.entitlementId]?.isActive == true
    }
}
