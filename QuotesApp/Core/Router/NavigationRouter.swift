import SwiftUI

final class NavigationRouter: ObservableObject, NavigationRouting {
    @Published var path = NavigationPath()
    @Published var presentedSheet: Route?
    @Published var sheetPath = NavigationPath()

    func push(route: Route) {
        if presentedSheet != nil {
            sheetPath.append(route)
        } else {
            path.append(route)
        }
    }

    func pop() {
        if presentedSheet != nil, !sheetPath.isEmpty {
            sheetPath.removeLast()
        } else {
            guard !path.isEmpty else { return }
            path.removeLast()
        }
    }

    func popAll() {
        if presentedSheet != nil {
            sheetPath = NavigationPath()
        } else {
            path = NavigationPath()
        }
    }

    func present(sheet: Route) {
        presentedSheet = sheet
        sheetPath = NavigationPath()
    }

    func dismissSheet() {
        presentedSheet = nil
        sheetPath = NavigationPath()
    }
}
