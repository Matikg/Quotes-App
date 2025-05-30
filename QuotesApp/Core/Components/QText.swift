//
//  CustomText.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 21/07/2024.
//

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
                return .caption
            case .small:
                return .callout
            case .medium:
                return .headline
            case .large:
                return .largeTitle
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
        return .custom(type.rawValue, size: size.rawValue, relativeTo: size.relativeTo)
    }
    
    var body: some View {
        Text(textKey)
            .font(font)
            .foregroundStyle(.accent)
    }
}
