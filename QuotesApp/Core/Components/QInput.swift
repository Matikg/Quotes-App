//
//  QInput.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 19/09/2024.
//

import SwiftUI

struct QInput: View {
    enum InputType {
        case oneLine
        case multiLine
    }
    
    @Binding private var text: String
    private let label: String
    private let inputType: InputType
    
    init(label: String, text: Binding<String>, type: InputType ) {
        self.label = label
        self._text = text
        self.inputType = type
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QText(label, type: .bold, size: .vsmall)
            
            switch inputType {
            case .oneLine:
                TextField("", text: $text)
                    .font(.custom("Merriweather-Regular", size: 12))
                    .foregroundStyle(.black)
                    .frame(height: 38)
                    .padding(.leading, 10)
                    .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
                
            case .multiLine:
                TextEditor(text: $text)
                    .font(.custom("Merriweather-Regular", size: 12))
                    .foregroundStyle(.black)
                    .frame(height: 162)
                    .scrollContentBackground(.hidden)
                    .padding(.leading, 5)
                    .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
            }
        }
    }
}
