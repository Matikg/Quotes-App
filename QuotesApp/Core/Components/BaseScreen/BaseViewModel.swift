import DependencyInjection
import Foundation

class BaseViewModel: ObservableObject {
    @Injected private var navigationRouter: any NavigationRouting

    var showBackButton: Bool {
        !navigationRouter.path.isEmpty
    }

    func navigateBack() {
        navigationRouter.pop()
    }
}
