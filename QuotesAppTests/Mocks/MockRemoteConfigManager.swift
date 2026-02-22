import Foundation
@testable import QuotesApp

final class MockRemoteConfigManager: RemoteConfigManagerInterface {
    private let values: [String: String]

    private(set) var fetchAndActivateCallsCount = 0
    private(set) var stringValueRequestedKeys = [String]()

    init(values: [String: String]) {
        self.values = values
    }

    func fetchAndActivate() async {
        fetchAndActivateCallsCount += 1
    }

    func stringValue(for key: String) -> String {
        stringValueRequestedKeys.append(key)
        return values[key] ?? ""
    }
}
