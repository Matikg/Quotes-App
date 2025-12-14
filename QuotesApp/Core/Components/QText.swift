import SwiftUI

struct QText: View {
    enum TextType: String {
        case regular = "Merriweather-Regular"
        case bold = "Merriweather-Bold"
        case italic = "Merriweather-Italic"
    }

    enum TextSize: CGFloat {
        case vsmall = 12
        case small = 16
        case medium = 18
        case large = 32

        var relativeTo: Font.TextStyle {
            switch self {
            case .vsmall:
                .caption
            case .small:
                .callout
            case .medium:
                .headline
            case .large:
                .largeTitle
            }
        }
    }

    private let textKey: LocalizedStringKey
    private let type: TextType
    private let size: TextSize

    init(_ textKey: String, type: TextType, size: TextSize) {
        self.textKey = LocalizedStringKey(textKey)
        self.type = type
        self.size = size
    }

    private var font: Font {
        .custom(type.rawValue, size: size.rawValue, relativeTo: size.relativeTo)
    }

    var body: some View {
        Text(textKey)
            .font(font)
            .foregroundStyle(Color.accentColor)
    }
}
