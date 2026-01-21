import DependencyInjection
import FirebaseMessaging
import Foundation
import UIKit

protocol PushNotificationsManagerInterface {
    var isPushEnabled: Bool { get }

    func isSystemPermissionGranted() async -> Bool
    func requestPermissionIfNeeded() async
    func enablePush() async
    func disablePush() async
}

final class PushNotificationsManager: PushNotificationsManagerInterface {
    @Injected private var crashlyticsManager: CrashlyticsManagerInterface

    private let pushTopic = Constants.pushNotificationsTopic

    var isPushEnabled: Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsConstants.NotificationsOnKey)
    }

    func isSystemPermissionGranted() async -> Bool {
        let status = await UNUserNotificationCenter
            .current()
            .notificationSettings()
            .authorizationStatus

        switch status {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined, .denied:
            return false
        @unknown default:
            return false
        }
    }

    func requestPermissionIfNeeded() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .notDetermined else {
            return
        }

        do {
            let granted = try await center.requestAuthorization(
                options: [.alert, .sound, .badge]
            )

            if granted {
                await enablePush()
            }
        } catch {
            crashlyticsManager.record(error)
        }
    }

    func enablePush() async {
        guard await isSystemPermissionGranted() else { return }
        guard !isPushEnabled else { return }

        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.NotificationsOnKey)

        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }

        do {
            try await Messaging.messaging().subscribe(toTopic: pushTopic)
        } catch {
            crashlyticsManager.record(error)
        }
    }

    func disablePush() async {
        UserDefaults.standard.set(false, forKey: UserDefaultsConstants.NotificationsOnKey)

        do {
            try await Messaging.messaging().unsubscribe(fromTopic: pushTopic)
            try await Messaging.messaging().deleteToken()
        } catch {
            crashlyticsManager.record(error)
        }
    }
}
