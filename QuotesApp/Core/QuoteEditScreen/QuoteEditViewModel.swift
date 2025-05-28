//
//  QuoteEditViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation
import DependencyInjection
import AVFoundation
import SwiftUI

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
    
    @Published var quoteInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var bookButtonLabel = ""
    @Published var errors = [InputError: String]()
    @Published var showCameraAccessAlert = false
    
    private let quoteId: UUID?
    
    init(existingQuote: Domain.QuoteItem? = nil) {
        self.quoteInput = existingQuote?.text ?? ""
        self.categoryInput = existingQuote?.category ?? ""
        self.noteInput = existingQuote?.note ?? ""
        self.quoteId = existingQuote?.id
        if let page = existingQuote?.page {
            self.pageInput = String(page)
        }
    }
    
    deinit {
        saveQuoteRepository.resetBook()
        saveScannedQuoteRepository.resetScannedQuote()
    }
    
    //MARK: - Methods
    
    func onAppear() {
        if let savedBook = saveQuoteRepository.selectedBook {
            bookButtonLabel = "\(savedBook.title), \(savedBook.author)"
        }
        
        if let scannedQuote = saveScannedQuoteRepository.scannedQuote {
            quoteInput = scannedQuote
        }
    }
    
    func saveQuote() {
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
}
