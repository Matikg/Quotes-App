import DependencyInjection
import RevenueCat
import UIKit

final class SettingsViewModel: ObservableObject {
    @Injected private var purchaseManager: PurchaseManagerInterface
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var analyticsManager: AnalyticsManagerInterface

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

    private var customerInfoTask: Task<Void, Never>?

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
    }

    deinit {
        customerInfoTask?.cancel()
    }

    @MainActor
    func onAppear() {
        Task {
            hasFullAccess = await purchaseManager.checkFullAccess()
            startObservingCustomerInfo()

            isAnalyticsOn = analyticsManager.isAnalyticsEnabled
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

    func showAboutUs() {
        navigationRouter.push(route: .aboutUs)
    }

    func toggleNotifications() {}

    func toggleAnalytics() {
        analyticsManager.setAnalyticsEnabled(isAnalyticsOn)
    }

    // MARK: - Private

    private func startObservingCustomerInfo() {
        customerInfoTask?.cancel()

        customerInfoTask = Task { [weak self] in
            guard let self else { return }
            for await info in purchaseManager.customerInfoUpdates() {
                let isActive = info.entitlements[Constants.entitlementId]?.isActive == true
                await MainActor.run {
                    self.hasFullAccess = isActive
                }
            }
        }
    }
}
