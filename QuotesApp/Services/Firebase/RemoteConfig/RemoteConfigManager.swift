import DependencyInjection
import FirebaseRemoteConfig
import Foundation

protocol RemoteConfigManagerInterface {
    func fetchAndActivate() async
    func stringValue(for key: String) -> String
}

final class RemoteConfigManager: RemoteConfigManagerInterface {
    @Injected private var crashlyticsManager: CrashlyticsManagerInterface

    private let remoteConfig: RemoteConfig

    init(remoteConfig: RemoteConfig = .remoteConfig()) {
        self.remoteConfig = remoteConfig

        let settings = RemoteConfigSettings()
        #if DEBUG
            settings.minimumFetchInterval = 0
        #else
            settings.minimumFetchInterval = 3600
        #endif
        remoteConfig.configSettings = settings

        remoteConfig.setDefaults([
            Constants.whatsNewRemoteConfigTitleKey: Constants.whatsNewDefaultTitle as NSObject,
            Constants.whatsNewRemoteConfigDescriptionKey: Constants.whatsNewDefaultDescription as NSObject
        ])
    }

    func fetchAndActivate() async {
        do {
            _ = try await remoteConfig.fetchAndActivate()
        } catch {
            crashlyticsManager.record(error)
        }
    }

    func stringValue(for key: String) -> String {
        remoteConfig.configValue(forKey: key).stringValue
    }
}
