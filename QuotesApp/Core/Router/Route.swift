//
//  Route.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

enum Route: Hashable, Identifiable, View {
    case quotes(book: Domain.BookItem)
    case details
    case edit
    case book
    case select
    
    var id: Int { hashValue }
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .quotes(let book):
            BookQuotesView(viewModel: BookQuotesViewModel(book: book))
        case .details:
            Text("Details View")
        case .edit:
            QuoteEditView()
        case .book:
            BookScreenView()
        case .select:
            SelectBookScreenView()
        }
    }
}
