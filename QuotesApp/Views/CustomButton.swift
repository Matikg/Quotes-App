//
//  CustomButton.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 10/07/2024.
//

import SwiftUI

struct CustomButton: View {
    private let label: String
    private let action: () -> Void
    
    init(label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .stroke(Color.accentColor, lineWidth: 3)
                    .frame(minWidth: 144)
                    .padding(.horizontal, 8)
                
                Text(label)
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}

#Preview {
    CustomButton(label: "Mock") {
    }
}
