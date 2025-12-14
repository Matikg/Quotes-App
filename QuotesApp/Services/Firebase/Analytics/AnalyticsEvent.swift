import FirebaseAnalytics
import FirebaseCore
import Foundation

enum AnalyticsEvent {
    case addToCart
    case purchase
    case viewItem
    case viewItemList
    case selectContent
    case search
    case login
    case signUp
    case screenView

    var name: String {
        switch self {
        case .addToCart: AnalyticsEventAddToCart
        case .purchase: AnalyticsEventPurchase
        case .viewItem: AnalyticsEventViewItem
        case .viewItemList: AnalyticsEventViewItemList
        case .selectContent: AnalyticsEventSelectContent
        case .search: AnalyticsEventSearch
        case .login: AnalyticsEventLogin
        case .signUp: AnalyticsEventSignUp
        case .screenView: AnalyticsEventScreenView
        }
    }
}
