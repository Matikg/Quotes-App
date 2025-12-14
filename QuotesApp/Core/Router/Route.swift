import RevenueCatUI
import SwiftUI

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
    case aboutUs

    var id: Int { hashValue }

    @ViewBuilder
    var body: some View {
        switch self {
        case let .quotes(book):
            BookQuotesView(viewModel: BookQuotesViewModel(book: book))
        case let .details(quote):
            QuoteDetailsView(viewModel: QuoteDetailsViewModel(quote: quote))
        case let .edit(existingQuote):
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
        case .aboutUs:
            AboutUsView()
        }
    }
}
