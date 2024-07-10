//
//  CustomButton.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 10/07/2024.
//

import SwiftUI

struct CustomButton: View {
    
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .stroke(Color.accentColor, lineWidth: 3)
                    .frame(width: 144, height: 46)
                    
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
