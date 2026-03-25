import SwiftUI

protocol NavigationRouting: AnyObject, ObservableObject {
    var path: NavigationPath { get set }
    var presentedSheet: Route? { get set }
    var sheetPath: NavigationPath { get set }

    func push(route: Route)
    func pop()
    func popAll()
    func present(sheet: Route)
    func dismissSheet()
}
