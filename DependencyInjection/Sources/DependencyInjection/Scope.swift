import Foundation

public enum Scope {
    case main
    case feature(String)
    case custom(String)

    public var identifier: String {
        switch self {
        case .main:
            "main"
        case let .feature(feature):
            "feature.\(feature)"
        case let .custom(name):
            "custom.\(name)"
        }
    }
}
