
import Foundation

public enum Scope {
    case main
    case feature(String)
    case custom(String)
    
    public var identifier: String {
        switch self {
        case .main:
            "main"
        case .feature(let feature):
            "feature.\(feature)"
        case .custom(let name):
            "custom.\(name)"
        }
    }
}


