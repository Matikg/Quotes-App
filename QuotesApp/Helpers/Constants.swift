import Foundation

enum Constants {
    static let entitlementId = "Unlock Books & Quotes"
    static let paywallConfigurationKey = "appl_acSBnwGhPvAkfmhVOLCtwUkPuNK"
    static let contactMail = "support@asthc.com"
    static let policyUrl = "https://bookquotesaver.asthc.com/privacy-policy"
    static let pushNotificationsTopic = "general"
    static let whatsNewRemoteConfigTitleKey = "whats_new_title"
    static let whatsNewRemoteConfigDescriptionKey = "whats_new_description"
    static let whatsNewDefaultTitle = "What's new"
    static let whatsNewDefaultDescription = "This is a mock description for the latest update. More details will be added soon."

    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
    }
}
