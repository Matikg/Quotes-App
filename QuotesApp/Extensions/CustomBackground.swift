//
//  CustomBackground.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 10/07/2024.
//

import SwiftUI

struct CustomBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.background)
    }
}

extension View {
    func globalBackground() -> some View {
        self.modifier(CustomBackground())
    }
}
