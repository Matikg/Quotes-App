import SwiftUI
@testable import QuotesApp

final class MockNavigationRouter: NavigationRouting {
    @Published var path: NavigationPath = .init()
    @Published var presentedSheet: Route? = nil
    
    private(set) var lastPushedRoute: Route? = nil
    
    private(set) var popCalled = false
    private(set) var popCallCount = 0
    
    func push(route: Route) {
        lastPushedRoute = route
    }
    func pop() {
        popCalled = true
        popCallCount += 1
    }
    func popAll() { }
    func set(navigationStack: NavigationPath) { }
    func present(sheet: Route) { }
}
