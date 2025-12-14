import FirebaseAnalytics
import FirebaseCore
import Foundation

protocol AnalyticsManagerInterface {
    var isAnalyticsEnabled: Bool { get }

    func setAnalyticsEnabled(_ isEnabled: Bool)
    func logEvent(name: String, parameters: [String: Any]?)
    func logEvent(event: AnalyticsEvent, parameters: [String: Any]?)
}

final class AnalyticsManager: AnalyticsManagerInterface {
    var isAnalyticsEnabled: Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsConstants.AnalyticsOnKey)
    }

    func setAnalyticsEnabled(_ isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: UserDefaultsConstants.AnalyticsOnKey)
        Analytics.setAnalyticsCollectionEnabled(isEnabled)
    }

    func logEvent(name: String, parameters: [String: Any]? = nil) {
        guard isAnalyticsEnabled else { return }
        Analytics.logEvent(name, parameters: parameters)
    }

    func logEvent(event: AnalyticsEvent, parameters: [String: Any]? = nil) {
        guard isAnalyticsEnabled else { return }
        Analytics.logEvent(event.name, parameters: parameters)
    }
}
