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
                    .frame(height: 46)
                    
                Text(label)
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 16)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .frame(minWidth: 144)
            .padding()
        }
    }
}

#Preview {
    CustomButton(label: "Mock") {
    }
}
