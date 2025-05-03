//
//  QuoteItem.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import Foundation

extension Domain {
    struct QuoteItem: Identifiable, Equatable, Hashable {
        let id: UUID
        let text: String
        let page: Int64
        let category: String
        let date: Date
        let note: String
    }
}

extension Domain.QuoteItem {
    init?(quoteEntity: QuoteEntity) {
        guard let id = quoteEntity.id, let text = quoteEntity.text, let category = quoteEntity.category, let date = quoteEntity.date else { return nil }
        
        self.id = id
        self.text = text
        self.page = quoteEntity.page
        self.category = category
        self.date = date
        self.note = quoteEntity.note ?? ""
    }
}
