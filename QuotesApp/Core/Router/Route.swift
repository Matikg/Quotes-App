//
//  Route.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 28/07/2024.
//

import SwiftUI
import RevenueCatUI

enum Route: Hashable, Identifiable, View {
    case quotes(book: Domain.BookItem)
    case details(quote: Domain.QuoteItem)
    case edit(existingQuote: Domain.QuoteItem?)
    case book
    case select
    case scan
    case review(image: UIImage)
    case paywall
    case settings
    
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
            LiveScannerView()
                .ignoresSafeArea()
        case let .review(image):
            ReviewView(viewModel: ReviewViewModel(image: image))
        case .paywall:
            PaywallView()
        case .settings:
            SettingsView()
        }
    }
}
