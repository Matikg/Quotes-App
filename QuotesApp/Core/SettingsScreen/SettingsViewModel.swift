import DependencyInjection
import RevenueCat
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Injected private var purchaseManager: PurchaseManagerInterface
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var analyticsManager: AnalyticsManagerInterface
    @Injected private var notificationsManager: PushNotificationsManagerInterface

    @Published private(set) var showNotificationsSwitch = false
    @Published private(set) var hasFullAccess = false

    @Published var isNotificationsOn = false {
        didSet { setNotifications() }
    }

    @Published var isAnalyticsOn = false {
        didSet { setAnalytics() }
    }

    private var customerInfoTask: Task<Void, Never>?
    private var notificationsPermissionTask: Task<Void, Never>?

    var appVersion: String {
        Constants.appVersion
    }

    deinit {
        customerInfoTask?.cancel()
        notificationsPermissionTask?.cancel()
    }

    func onAppear() async {
        startObservingCustomerInfo()
        startObservingNotificationsPermission()

        hasFullAccess = await purchaseManager.checkFullAccess()
        isAnalyticsOn = analyticsManager.isAnalyticsEnabled

        let granted = await notificationsManager.isSystemPermissionGranted()
        showNotificationsSwitch = granted
        isNotificationsOn = granted && notificationsManager.isPushEnabled
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

    func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    func showAboutUs() {
        navigationRouter.push(route: .aboutUs)
    }

    func dismissSettings() {
        navigationRouter.dismissSheet()
    }

    private func setNotifications() {
        Task {
            if isNotificationsOn {
                await notificationsManager.enablePush()
            } else {
                await notificationsManager.disablePush()
            }
        }
    }

    private func setAnalytics() {
        analyticsManager.setAnalyticsEnabled(isAnalyticsOn)
    }

    // MARK: - Observers

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

    private func startObservingNotificationsPermission() {
        notificationsPermissionTask?.cancel()

        notificationsPermissionTask = Task { [weak self] in
            guard let self else { return }

            let center = NotificationCenter.default

            for await _ in center.notifications(named: UIApplication.willEnterForegroundNotification) {
                let isEnabled = await notificationsManager.isSystemPermissionGranted()

                await MainActor.run {
                    self.showNotificationsSwitch = isEnabled
                    self.isNotificationsOn = isEnabled
                }
            }
        }
    }
}
