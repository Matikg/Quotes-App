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

    var isPushEnabled: Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsConstants.NotificationsOnKey)
    }

    func isSystemPermissionGranted() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized
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
            try await Messaging.messaging().subscribe(toTopic: "general")
        } catch {
            crashlyticsManager.record(error)
        }
    }

    func disablePush() async {
        UserDefaults.standard.set(false, forKey: UserDefaultsConstants.NotificationsOnKey)

        do {
            try await Messaging.messaging().unsubscribe(fromTopic: "general")
            try await Messaging.messaging().deleteToken()
        } catch {
            crashlyticsManager.record(error)
        }
    }
}
