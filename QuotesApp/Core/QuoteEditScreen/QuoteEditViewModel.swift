//
//  QuoteEditViewModel.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import Foundation

final class QuoteEditViewModel: ObservableObject {
    @Published var quoteInput: String? = nil
    @Published var bookInput = ""
    @Published var categoryInput = ""
    @Published var pageInput = ""
    @Published var noteInput = ""
    @Published var showError = false
    
    func saveQuote() {
        if quoteInput != nil {
            print("Quote saved!")
        }
        else {
            showError = true
        }
    }
}
