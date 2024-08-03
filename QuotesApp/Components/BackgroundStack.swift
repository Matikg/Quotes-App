//
//  BackgroundStack.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/07/2024.
//

import SwiftUI

struct BackgroundStack<Content: View>: View {
    let backgroundColor = Color.background
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            content()
        }
    }
}
