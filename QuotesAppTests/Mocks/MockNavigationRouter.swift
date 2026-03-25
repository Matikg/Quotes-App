@testable import QuotesApp
import SwiftUI

final class MockNavigationRouter: NavigationRouting {
    @Published var path: NavigationPath = .init()
    @Published var presentedSheet: Route?
    @Published var sheetPath: NavigationPath = .init()

    private(set) var lastPushedRoute: Route?
    private(set) var lastPresentedSheet: Route?
    private(set) var presentSheetCallCount = 0

    private(set) var popCalled = false
    private(set) var popCallCount = 0
    private(set) var dismissSheetCalled = false
    private(set) var dismissSheetCallCount = 0

    func push(route: Route) {
        lastPushedRoute = route
    }

    func pop() {
        popCalled = true
        popCallCount += 1
    }

    func popAll() {}

    func present(sheet: Route) {
        lastPresentedSheet = sheet
        presentSheetCallCount += 1
    }

    func dismissSheet() {
        dismissSheetCalled = true
        dismissSheetCallCount += 1
    }
}
