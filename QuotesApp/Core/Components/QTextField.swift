//
//  QTextField.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 17/09/2024.
//

import SwiftUI

struct QTextField: View {
    private let label: String
    @Binding private var input: String
    
    init(_ titleKey: String, input: Binding<String>) {
        self.label = titleKey
        self._input = input
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QText(label, type: .bold, size: .vsmall)
            
            TextField("", text: $input)
                .font(.custom("Merriweather-Regular", size: 12))
                .frame(height: 38)
                .padding(.leading, 10)
                .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
        }
    }
}
