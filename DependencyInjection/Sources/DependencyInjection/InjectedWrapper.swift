import Foundation

@propertyWrapper
public struct Injected<T> {
    private let scope: Scope
    private var storage: T?

    public var wrappedValue: T {
        mutating get {
            if let value = storage {
                return value
            }
            guard let resolved = ContainerManager.shared.container(for: scope).resolve(T.self) else {
                fatalError("Dependency of type \(T.self) not registered in scope: \(scope.identifier)")
            }
            storage = resolved
            return resolved
        }
        set {
            storage = newValue
        }
    }

    public init(scope: Scope = .main) {
        self.scope = scope
    }
}
