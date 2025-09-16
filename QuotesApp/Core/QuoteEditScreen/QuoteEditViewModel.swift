//
//  QuoteEditViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation
import DependencyInjection
import SwiftUI
import Combine

final class QuoteEditViewModel: ObservableObject {
    enum InputError: String, CaseIterable {
        case quote = "Quote_empty_dialog"
        case page = "Page_empty_dialog"
        case pageRange = "Page_range_dialog"
        case category = "Category_empty_dialog"
        case book = "Book_empty_dialog"
    }
    
    @Injected private var coreDataManager: CoreDataManagerInterface
    @Injected private var navigationRouter: any NavigationRouting
    @Injected private var saveQuoteRepository: SaveQuoteRepositoryInterface
    @Injected private var saveScannedQuoteRepository: SaveScannedQuoteRepositoryInterface
    @Injected private var crashlyticsManager: CrashlyticsManagerInterface
    @Injected private var cameraAccessManager: CameraAccessManagerInterface
    @Injected private var purchaseManager: PurchaseManagerInterface
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var bookButtonLabel = ""
    @Published var errors = [InputError: String]()
    @Published var showCameraAccessAlert = false
    @Published var categoriesHint: [String] = []
    @Published var isCategoryFocused = false
    
    private let quoteId: UUID?
    private let maxPageNumber = 5000
    private var categories: [String] = []
    private var cancellables = Set<AnyCancellable>()
    private var didSelectCategory = false
    
    init(existingQuote: Domain.QuoteItem? = nil) {
        self.quoteInput = existingQuote?.text ?? ""
        self.categoryInput = existingQuote?.category ?? ""
        self.noteInput = existingQuote?.note ?? ""
        self.quoteId = existingQuote?.id
        if let page = existingQuote?.page {
            self.pageInput = String(page)
        }
        categories = coreDataManager.fetchCategories()
        observeCategory()
    }
    
    deinit {
        saveQuoteRepository.resetBook()
        saveScannedQuoteRepository.resetScannedQuote()
    }
    
    //MARK: - Methods
    
    @MainActor
    func saveQuote() {
        Task {
            let canAddQuote = await purchaseManager.checkPremiumAction()
            if canAddQuote {
                performSave()
            } else {
                navigationRouter.present(sheet: .paywall)
            }
        }
    }
    
    @MainActor
    func scanQuote() async {
        // First time
        if cameraAccessManager.shouldAskForCameraAccess() {
            let granted = await cameraAccessManager.checkCameraAccess()
            if granted == .authorized {
                navigationRouter.push(route: .scan)
            }
            return
        }
        
        //Second time
        let access = await cameraAccessManager.checkCameraAccess()
        
        switch access {
        case .authorized:
            navigationRouter.push(route: .scan)
        case .denied:
            showCameraAccessAlert = true
        case .notDetermined:
            break
        }
    }
    
    func onAppear() {
        if let savedBook = saveQuoteRepository.selectedBook {
            bookButtonLabel = "\(savedBook.title), \(savedBook.author)"
        }
        
        if let scannedQuote = saveScannedQuoteRepository.scannedQuote {
            quoteInput = scannedQuote
        }
    }
    
    func selectCategory(_ category: String) {
        categoryInput = category
        categoriesHint = []
        didSelectCategory = true
    }
    
    func addBook() {
        let route: Route = coreDataManager.fetchBooks().isEmpty ? .book : .select
        navigationRouter.push(route: route)
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func performSave() {
        validate()
        
        guard errors.isEmpty else { return }
        
        guard let page = Int(pageInput) else {
            crashlyticsManager.log(CrashReason.QuoteEdit.invalidInput)
            return
        }
        guard let selectedBook = saveQuoteRepository.selectedBook else {
            crashlyticsManager.log(CrashReason.QuoteEdit.noBookSelected)
            return
        }
        guard let bookEntity = coreDataManager.fetchBookEntity(for: selectedBook) else { return }
        
        coreDataManager.saveQuote(
            to: bookEntity,
            text: quoteInput,
            category: categoryInput,
            page: page,
            note: noteInput,
            quoteId: quoteId
        )
        navigationRouter.popAll()
        navigationRouter.push(route: .quotes(book: selectedBook))
    }
    
    private func validate() {
        errors.removeAll()
        
        validatePage(input: pageInput, maxPage: maxPageNumber)
        
        if quoteInput.isEmpty {
            errors[.quote] = InputError.quote.rawValue
        }
        if categoryInput.isEmpty {
            errors[.category] = InputError.category.rawValue
        }
        if saveQuoteRepository.selectedBook == nil {
            errors[.book] = InputError.book.rawValue
        }
    }
    
    private func validatePage(input page: String, maxPage: Int) {
        guard !pageInput.isEmpty, let page = Int(pageInput) else {
            errors[.page] = InputError.page.rawValue
            return
        }
        
        guard (1...maxPage).contains(page) else {
            errors[.page] = InputError.pageRange.rawValue
            return
        }
    }
    
    private func observeCategory() {
        Publishers.CombineLatest($categoryInput, $isCategoryFocused)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] (input, focused) in
                guard let self else { return }
                
                if !focused {
                    categoriesHint = []
                    return
                }
                
                let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if didSelectCategory {
                    categoriesHint = []
                    didSelectCategory = false
                    return
                }
                
                if trimmed.isEmpty {
                    categoriesHint = categories
                } else {
                    categoriesHint = categories.filter {
                        $0.localizedCaseInsensitiveContains(trimmed)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
