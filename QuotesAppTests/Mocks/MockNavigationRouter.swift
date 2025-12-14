@testable import QuotesApp
import SwiftUI

final class MockNavigationRouter: NavigationRouting {
    @Published var path: NavigationPath = .init()
    @Published var presentedSheet: Route?

    private(set) var lastPushedRoute: Route?

    private(set) var popCalled = false
    private(set) var popCallCount = 0

    func push(route: Route) {
        lastPushedRoute = route
    }

    func pop() {
        popCalled = true
        popCallCount += 1
    }

    func popAll() {}
    func set(navigationStack _: NavigationPath) {}
    func present(sheet _: Route) {}
}
