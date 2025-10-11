import UIKit
import DependencyInjection

final class SettingsViewModel: ObservableObject {
    @Injected private var purchaseManager: PurchaseManagerInterface
    @Injected private var navigationRouter: any NavigationRouting
    
    @Published private(set) var hasFullAccess = false
    @Published var isNotificationsOn = false {
        didSet {
            toggleNotifications()
        }
    }
    @Published var isAnalyticsOn = false {
        didSet {
            toggleAnalytics()
        }
    }
    
    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
    }
    
    @MainActor
    func onAppear() {
        Task {
            self.hasFullAccess = await self.purchaseManager.checkFullAccess()
        }
    }
    
    func showPaywall() {
        navigationRouter.present(sheet: .paywall)
    }
    
    func openMail() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = Constants.contactMail
        
        guard let url = components.url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openPrivacyPolicy() {
        guard let url = URL(string: Constants.policyUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func toggleNotifications() {
        
    }
    
    func toggleAnalytics() {
        
    }
}
