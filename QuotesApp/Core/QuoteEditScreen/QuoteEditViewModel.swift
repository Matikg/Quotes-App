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
    @Published var isCategoriesInputActive = false
    
    private let quoteId: UUID?
    private var categories: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
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
        
        if quoteInput.isEmpty {
            errors[.quote] = InputError.quote.rawValue
        }
        if pageInput.isEmpty || Int(pageInput) == nil {
            errors[.page] = InputError.page.rawValue
        }
        if categoryInput.isEmpty {
            errors[.category] = InputError.category.rawValue
        }
        if saveQuoteRepository.selectedBook == nil {
            errors[.book] = InputError.book.rawValue
        }
    }
    
    private func observeCategory() {
        Publishers
            .CombineLatest(
                $categoryInput
                    .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
                    .removeDuplicates(),
                
                $isCategoriesInputActive
                    .removeDuplicates()
            )
            .map { [categories] input, isActive -> [String] in
                guard isActive else { return [] }
                let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard !trimmed.isEmpty else { return categories }
                return categories.filter {
                    $0.localizedCaseInsensitiveContains(trimmed)
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] hints in
                self?.categoriesHint = hints
            }
            .store(in: &cancellables)
    }
}
