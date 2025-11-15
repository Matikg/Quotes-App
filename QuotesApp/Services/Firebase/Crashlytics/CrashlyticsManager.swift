import Foundation
import Firebase
import FirebaseCrashlytics

protocol CrashlyticsManagerInterface {
    func record(_ error: Error)
    func log(_ message: String)
}

final class CrashlyticsManager: CrashlyticsManagerInterface {
    func record(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
}
