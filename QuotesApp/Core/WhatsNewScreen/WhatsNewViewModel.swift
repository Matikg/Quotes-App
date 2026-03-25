import DependencyInjection
import Foundation

@MainActor
final class WhatsNewViewModel: ObservableObject {
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var remoteConfigManager: RemoteConfigManagerInterface

    @Published private(set) var title = Constants.whatsNewDefaultTitle
    @Published private(set) var description = Constants.whatsNewDefaultDescription
    @Published private(set) var isLoading = true

    var appVersion: String {
        Constants.appVersion
    }

    func dismissWhatsNew() {
        navigationRouter.dismissSheet()
    }

    func onAppear() async {
        guard isLoading else { return }
        defer { isLoading = false }

        await remoteConfigManager.fetchAndActivate()

        let fetchedTitle = remoteConfigManager.stringValue(for: Constants.whatsNewRemoteConfigTitleKey)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let fetchedDescription = remoteConfigManager.stringValue(for: Constants.whatsNewRemoteConfigDescriptionKey)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if !fetchedTitle.isEmpty {
            title = fetchedTitle
        }

        if !fetchedDescription.isEmpty {
            description = fetchedDescription
        }
    }
}
