import SwiftUI

extension Domain {
    struct RecognizedTextItem: Identifiable, Equatable, Hashable {
        let id = UUID()
        let string: String
        let boundingBox: CGRect
    }
}
