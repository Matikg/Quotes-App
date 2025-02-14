//
//  Route.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

enum Route: Hashable, Identifiable, View {
    case quotes
    case details
    case edit
    case book
    
    var id: Int { hashValue }
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .quotes:
            Text("Quotes View")
        case .details:
            Text("Details View")
        case .edit:
            QuoteEditView()
        case .book:
            BookScreenView()
        }
    }
}
