//
//  InjectionKeys.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 04/08/2024.
//

import Foundation
import DependencyInjection

// MARK: - DI Scope
enum DIScope {
    case main
    case feature(String)
    case custom(String)
    
    var identifier: String {
        switch self {
        case .main:
            "main"
        case .feature(let name):
            "feature.\(name)"
        case .custom(let name):
            "custom.\(name)"
        }
    }
}

// MARK: - DI Container Protocol
protocol DIContainerInterface {
    func register<T>(_ type: T.Type, instance: T)
    func resolve<T>(_ type: T.Type) -> T?
    func reset()
}

// MARK: - Container Implementation
final class DIContainer: DIContainerInterface {
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        dependencies[key] = instance
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
    
    func reset() {
        dependencies.removeAll()
    }
}

// MARK: - Container Manager
final class DIContainerManager {
    static let shared = DIContainerManager()
    private var containers: [String: DIContainerInterface] = [:]
    
    func container(for scope: DIScope) -> DIContainerInterface {
        if let existing = containers[scope.identifier] {
            return existing
        }
        let container = DIContainer()
        containers[scope.identifier] = container
        return container
    }
    
    func removeContainer(for scope: DIScope) {
        containers[scope.identifier]?.reset()
        containers.removeValue(forKey: scope.identifier)
    }
}

// MARK: - Injectable Property Wrapper
@propertyWrapper
struct Injected<T> {
    private let scope: DIScope
    private var storage: T?
    
    var wrappedValue: T {
        mutating get {
            if let value = storage {
                return value
            }
            guard let resolved = DIContainerManager.shared.container(for: scope).resolve(T.self) else {
                fatalError("Dependency of type \(T.self) not registered in scope: \(scope.identifier)")
            }
            storage = resolved
            return resolved
        }
        set {
            storage = newValue
        }
    }
    
    init(scope: DIScope = .main) {
        self.scope = scope
    }
}

// MARK: - Register defaults
extension DIContainerManager {
    func registerDefaults() {
        let container = container(for: .main)
        container.register(CoreDataManagerProtocol.self, instance: CoreDataManager())
        container.register(ApiService.self, instance: ApiService())
    }
}
