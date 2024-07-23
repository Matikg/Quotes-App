//
//  CustomText.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 21/07/2024.
//

import SwiftUI

struct QText: View {
    enum TextType {
        case regular, bold, italic
    }
    
    enum TextSize {
        case vsmall, small, medium, large
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
        let fontName: String
        
        switch type {
        case .regular:
            fontName = "Merriweather-Regular"
        case .bold:
            fontName = "Merriweather-Bold"
        case .italic:
            fontName = "Merriweather-Italic"
        }
        
        switch size {
        case .small:
            return .custom(fontName, size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
        case .medium:
            return .custom(fontName, size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        case .large:
            return .custom(fontName, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        case .vsmall:
            return .custom(fontName, size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        }
    }
    
    var body: some View {
        Text(textKey)
            .font(font)
    }
}
