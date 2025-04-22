//
//  Route.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI

enum Route: Hashable, Identifiable, View {
    case quotes(book: Domain.BookItem)
    case details(quote: Domain.QuoteItem)
    case edit(existingQuote: Domain.QuoteItem?)
    case book
    case select
    case scan
    
    var id: Int { hashValue }
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .quotes(let book):
            BookQuotesView(viewModel: BookQuotesViewModel(book: book))
        case .details(let quote):
            QuoteDetailsView(viewModel: QuoteDetailsViewModel(quote: quote))
        case .edit(let existingQuote):
            QuoteEditView(viewModel: QuoteEditViewModel(existingQuote: existingQuote))
        case .book:
            BookScreenView()
        case .select:
            SelectBookScreenView()
        case .scan:
            ScannerView()
        }
    }
}
