//
//  QInput.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 19/09/2024.
//

import SwiftUI

private struct QInputIsEditingPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct QInput: View {
    enum InputType {
        case oneLine
        case multiLine
    }
    
    @Binding private var text: String
    private let label: String
    private let inputType: InputType
    private let isLoading: Bool
    private let error: String?
    
    @FocusState private var isFocused: Bool
    @State private var isEditing: Bool = false
    
    init(
        label: String,
        text: Binding<String>,
        type: InputType,
        isLoading: Bool = false,
        error: String? = nil
    ) {
        self.label = label
        self._text = text
        self.inputType = type
        self.isLoading = isLoading
        self.error = error
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QText(label, type: .bold, size: .vsmall)
            
            switch inputType {
            case .oneLine:
                HStack {
                    TextField(
                        "",
                        text: $text,
                        onEditingChanged: { editing in
                            isEditing = editing
                            isFocused = editing
                        }
                    )
                    .font(.custom("Merriweather-Regular", size: 12))
                    .foregroundStyle(.accent)
                    .onSubmit {
                        isEditing = false
                    }
                    
                    if isLoading {
                        QSpinner().scaleEffect(0.4)
                    }
                }
                .frame(height: 38)
                .padding(.leading, 10)
                .background(Rectangle().stroke(error == nil ? .accent : .red, lineWidth: 1))
                
            case .multiLine:
                TextEditor(text: $text)
                    .font(.custom("Merriweather-Regular", size: 12))
                    .foregroundStyle(.accent)
                    .frame(height: 162)
                    .scrollContentBackground(.hidden)
                    .padding(.leading, 5)
                    .background(Rectangle().stroke(error == nil ? .accent : .red, lineWidth: 1))
                    .focused($isFocused)
                    .onChange(of: isFocused) {
                        isEditing = isFocused
                    }
            }
            
            if let error {
                QText(error, type: .regular, size: .vsmall)
                    .accentColor(.red)
            }
        }
        .preference(key: QInputIsEditingPreferenceKey.self, value: isEditing)
    }
}

extension QInput {
    /// Call this from a parent view to bind the `isEditing` state out of QInput.
    /// Example:
    ///     @State private var keyboardIsActive = false
    ///     QInput(...).editing($keyboardIsActive)
    func editing(_ binding: Binding<Bool>) -> some View {
        self.onPreferenceChange(QInputIsEditingPreferenceKey.self) { newValue in
            binding.wrappedValue = newValue
        }
    }
}

#Preview {
    VStack {
        QInput(label: "label", text: .constant("text"), type: .oneLine)
            .padding(.bottom, 20)
        QInput(label: "label", text: .constant("text"), type: .oneLine, isLoading: true)
            .padding(.bottom, 20)
        QInput(label: "label", text: .constant("text"), type: .multiLine)
            .padding(.bottom, 20)
    }
}
