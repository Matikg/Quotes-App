import SwiftUI
import DependencyInjection
import Firebase

@main
struct AppEntry: App {
    @StateObject private var navigationRouter: NavigationRouter
    @StateObject private var rootScreenViewModel = RootScreenViewModel()
    
    init() {
        let router = NavigationRouter()
        _navigationRouter = StateObject(wrappedValue: router)
        
        FirebaseApp.configure()
        
        ContainerManager.shared.registerDefaults()
        ContainerManager.shared
            .container(for: .main)
            .register(
                (any NavigationRouting).self,
                instance: router
            )
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationRouter.path) {
                RootScreenView(viewModel: rootScreenViewModel)
                    .navigationDestination(for: Route.self, destination: { $0 })
                    .sheet(item: $navigationRouter.presentedSheet, content: { $0 })
            }
        }
    }
}
