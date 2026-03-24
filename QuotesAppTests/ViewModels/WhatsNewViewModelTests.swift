import DependencyInjection
@testable import QuotesApp
import Testing

@MainActor
@Suite(.serialized)
struct WhatsNewViewModelTests {
    @Test
    func onAppear_updatesTitleAndDescriptionFromRemoteConfig() async {
        let (sut, remoteConfigMock) = makeSUT(
            title: "  New title  ",
            description: "\nNew description\n"
        )
        defer { ContainerManager.shared.removeContainer(for: .main) }

        await sut.onAppear()

        #expect(remoteConfigMock.fetchAndActivateCallsCount == 1)
        #expect(sut.isLoading == false)
        #expect(sut.title == "New title")
        #expect(sut.description == "New description")
    }

    @Test
    func onAppear_whenRemoteConfigIsEmpty_keepsDefaultValues() async {
        let (sut, remoteConfigMock) = makeSUT(
            title: "   ",
            description: "\n   \n"
        )
        defer { ContainerManager.shared.removeContainer(for: .main) }

        await sut.onAppear()

        #expect(remoteConfigMock.fetchAndActivateCallsCount == 1)
        #expect(sut.isLoading == false)
        #expect(sut.title == Constants.whatsNewDefaultTitle)
        #expect(sut.description == Constants.whatsNewDefaultDescription)
    }

    @Test
    func onAppear_calledTwice_fetchesRemoteConfigOnlyOnce() async {
        let (sut, remoteConfigMock) = makeSUT(
            title: "Updated title",
            description: "Updated description"
        )
        defer { ContainerManager.shared.removeContainer(for: .main) }

        await sut.onAppear()
        await sut.onAppear()

        #expect(remoteConfigMock.fetchAndActivateCallsCount == 1)
        #expect(remoteConfigMock.stringValueRequestedKeys.count == 2)
        #expect(sut.isLoading == false)
    }

    @Test
    func appVersion_returnsCurrentAppVersion() {
        let (sut, _) = makeSUT()
        defer { ContainerManager.shared.removeContainer(for: .main) }

        #expect(sut.appVersion == Constants.appVersion)
    }

    private func makeSUT(
        title: String = "",
        description: String = ""
    ) -> (WhatsNewViewModel, MockRemoteConfigManager) {
        let remoteConfigMock = MockRemoteConfigManager(
            values: [
                Constants.whatsNewRemoteConfigTitleKey: title,
                Constants.whatsNewRemoteConfigDescriptionKey: description
            ]
        )

        let container = ContainerManager.shared.container(for: .main)
        container.reset()
        container.register(RemoteConfigManagerInterface.self, instance: remoteConfigMock)

        let sut = WhatsNewViewModel()
        return (sut, remoteConfigMock)
    }
}
