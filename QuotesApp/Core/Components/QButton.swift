//
//  CustomButton.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 10/07/2024.
//

import SwiftUI

struct QButton: View {
    enum ButtonState {
        case idle
        case loading
    }
    
    private let label: String
    private let action: () -> Void
    private let state: ButtonState
    
    init(label: String, state: ButtonState = .idle, action: @escaping () -> Void) {
        self.label = label
        self.state = state
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .stroke(.accent, lineWidth: 3)
                    .frame(height: 46)
                    .padding(.horizontal, 100)
                
                switch state {
                case .idle:
                    QText(label, type: .regular, size: .small)
                        .padding(.horizontal, 16)
                        .fixedSize(horizontal: true, vertical: false)
                case .loading:
                    ProgressView()
                        .tint(.accent)
                }
            }
            .frame(minWidth: 144)
            .padding()
        }
        .disabled(state == .loading)
    }
}
