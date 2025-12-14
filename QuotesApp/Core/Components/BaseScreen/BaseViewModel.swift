import DependencyInjection
import Foundation

class BaseViewModel: ObservableObject {
    @Injected var navigationRouter: any NavigationRouting

    var showBackButton: Bool {
        !navigationRouter.path.isEmpty
    }

    func navigateBack() {
        navigationRouter.pop()
    }
}
