
import Foundation

public final class ContainerManager {
    public static let shared = ContainerManager()
    private var containers: [String: ContainerInterface] = [:]
    
    public func container(for scope: Scope) -> ContainerInterface {
        if let existing = containers[scope.identifier] {
            return existing
        }
        let container = Container()
        containers[scope.identifier] = container
        return container
    }
    
    public func removeContainer(for scope: Scope) {
        containers[scope.identifier]?.reset()
        containers.removeValue(forKey: scope.identifier)
    }
}
