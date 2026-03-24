import DependencyInjection
import SwiftUI

@MainActor
final class RootScreenViewModel: ObservableObject {
    @Injected private var notificationsManager: PushNotificationsManagerInterface

    @AppStorage(UserDefaultsConstants.FirstLaunchKey) var isFirstLaunch: Bool = true
    let mainScreenViewModel = MainScreenViewModel()

    func showPushPermissionAlertIfNeeded() async {
        await notificationsManager.requestPermissionIfNeeded()
    }
}
