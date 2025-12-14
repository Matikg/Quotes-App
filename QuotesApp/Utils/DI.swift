import DependencyInjection
import Foundation

extension ContainerManager {
    func registerDefaults() {
        let container = container(for: .main)
        container.register(CoreDataManagerInterface.self, instance: CoreDataManager())
        container.register(BookApiService.self, instance: BookApiService())
        container.register(SaveQuoteRepositoryInterface.self, instance: SaveQuoteRepository())
        container.register(SaveScannedQuoteRepositoryInterface.self, instance: SaveScannedQuoteRepository())
        container.register(CrashlyticsManagerInterface.self, instance: CrashlyticsManager())
        container.register(AnalyticsManagerInterface.self, instance: AnalyticsManager())
        container.register(PurchaseManagerInterface.self, instance: PurchaseManager())
        container.register(CameraAccessManagerInterface.self, instance: CameraAccessManager())
    }
}

enum FeatureName: String {
    case `default`
}
