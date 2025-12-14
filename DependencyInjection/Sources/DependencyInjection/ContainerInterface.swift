import Foundation

public protocol ContainerInterface {
    func register<T>(_ type: T.Type, instance: T)
    func resolve<T>(_ type: T.Type) -> T?
    func reset()
}
