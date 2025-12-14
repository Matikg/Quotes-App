import Foundation
@testable import QuotesApp
import RevenueCat

final class MockPurchaseManager: PurchaseManagerInterface {
    func checkPremiumAction() async -> Bool {
        true
    }

    func checkFullAccess() async -> Bool {
        true
    }

    func customerInfoUpdates() -> AsyncStream<CustomerInfo> {
        AsyncStream { continuation in
            continuation.finish()
        }
    }
}
