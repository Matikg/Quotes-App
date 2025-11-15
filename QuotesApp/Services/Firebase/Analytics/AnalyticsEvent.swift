import Foundation
import FirebaseCore
import FirebaseAnalytics

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
        case .addToCart:
            return AnalyticsEventAddToCart
        case .purchase:
            return AnalyticsEventPurchase
        case .viewItem:
            return AnalyticsEventViewItem
        case .viewItemList:
            return AnalyticsEventViewItemList
        case .selectContent:
            return AnalyticsEventSelectContent
        case .search:
            return AnalyticsEventSearch
        case .login:
            return AnalyticsEventLogin
        case .signUp:
            return AnalyticsEventSignUp
        case .screenView:
            return AnalyticsEventScreenView
        }
    }
}