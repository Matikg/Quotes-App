//
//  SuggestedBookItem.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 27/04/2025.
//

import Foundation

extension Domain {
    struct SuggestedBookItem: Identifiable {
        enum Cover {
            case remote(URL)
            case `default`
        }
        
        let id = UUID()
        let title: String
        let author: String
        let cover: Cover
        var coverImageData: Data?
    }
}

extension Domain.SuggestedBookItem {
    init?(model: BookDoc) {
        guard let title = model.title else { return nil }
        self.title = title
        self.author = model.authorName?.joined(separator: ", ") ?? ""
        self.coverImageData = nil
        
        if let editionKey = model.coverEditionKey, let url = URL(string: "https://covers.openlibrary.org/b/olid/\(editionKey)-M.jpg?default=false") {
            self.cover = .remote(url)
        } else if let coverKey = model.coverKey, let url = URL(string: "https://covers.openlibrary.org/b/id/\(coverKey)-M.jpg?default=false") {
            self.cover = .remote(url)
        } else {
            self.cover = .default
        }
    }
}


