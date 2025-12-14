import Foundation

public final class Container: ContainerInterface {
    private var dependencies: [String: Any] = [:]

    public init() {}

    public func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        guard dependencies[key] == nil else { return }
        dependencies[key] = instance
    }

    public func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }

    public func reset() {
        dependencies.removeAll()
    }
}
