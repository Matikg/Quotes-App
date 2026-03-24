import DependencyInjection
import SwiftUI

@MainActor
final class MainScreenViewModel: ObservableObject {
    enum BookListState {
        case empty
        case loaded([Domain.BookItem])
    }

    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var coreDataManager: CoreDataManagerInterface
    @Injected private var purchaseManager: PurchaseManagerInterface
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    @Injected private var remoteConfigManager: RemoteConfigManagerInterface

    @Published private(set) var state: BookListState = .empty
    @Published private(set) var buttonState: QButton.ButtonState = .idle
    @Published var bookToDelete: Domain.BookItem?
    @Published private(set) var shouldShowUpdateBanner = false

    // MARK: - Methods

    func addQuote() async {
        buttonState = .loading
        let canAddQuote = await purchaseManager.checkPremiumAction()
        buttonState = .idle

        if canAddQuote {
            navigationRouter.push(route: .edit(existingQuote: nil))
        } else {
            navigationRouter.present(sheet: .paywall)
        }
    }

    func getBooks() {
        let fetchedBooks = coreDataManager.fetchBooks()
        let bookItems = fetchedBooks.compactMap(Domain.BookItem.init)
        state = bookItems.isEmpty ? .empty : .loaded(bookItems)

        Task { [weak self] in
            await self?.updateBannerVisibility()
        }
    }

    func selectBook(_ book: Domain.BookItem) {
        if book.quotesNumber == 0 {
            saveQuoteRepository.selectBook(book)
            navigationRouter.push(route: .edit(existingQuote: nil))
        } else {
            navigationRouter.push(route: .quotes(book: book))
        }
    }

    func deleteBook(_ book: Domain.BookItem) {
        coreDataManager.deleteBook(book: book)

        switch state {
        case .empty:
            break
        case let .loaded(books):
            let updatedBooks = books.filter { $0.id != book.id }
            state = updatedBooks.isEmpty ? .empty : .loaded(updatedBooks)
        }

        cancelDeleteBook()
    }

    func cancelDeleteBook() {
        bookToDelete = nil
    }

    func openSettings() {
        navigationRouter.push(route: .settings)
    }

    func openWhatsNew() {
        navigationRouter.present(sheet: .whatsNew)
    }

    func dismissUpdateBanner() {
        UserDefaults.standard.set(
            Constants.appVersion,
            forKey: UserDefaultsConstants.WhatsNewBannerDismissedVersionKey
        )
        shouldShowUpdateBanner = false
    }

    @MainActor
    private func updateBannerVisibility() async {
        await remoteConfigManager.fetchAndActivate()

        let configVersion = remoteConfigManager
            .stringValue(for: Constants.whatsNewRemoteConfigAppVersionKey)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let dismissedVersion = UserDefaults.standard.string(
            forKey: UserDefaultsConstants.WhatsNewBannerDismissedVersionKey
        )

        shouldShowUpdateBanner = !configVersion.isEmpty &&
            configVersion == Constants.appVersion &&
            dismissedVersion != Constants.appVersion
    }
}
