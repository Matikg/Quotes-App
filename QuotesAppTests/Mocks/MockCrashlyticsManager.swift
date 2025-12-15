import Foundation
@testable import QuotesApp

final class MockCrashlyticsManager: CrashlyticsManagerInterface {
    private(set) var recordedErrors: [Error] = []
    private(set) var loggedMessages: [String] = []

    func record(_ error: Error) {
        recordedErrors.append(error)
    }

    func log(_ message: String) {
        loggedMessages.append(message)
    }
}
