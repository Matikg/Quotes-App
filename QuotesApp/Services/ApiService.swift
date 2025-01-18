//
//  ApiService.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import Foundation

struct SearchResponse: Decodable {
    let numFound: Int?
    let docs: [BookDoc]?
}

struct BookDoc: Decodable {
    let title: String?
    let authorName: [String]?
    let coverEditionKey: String?
    let coverKey: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
        case coverEditionKey = "cover_edition_key"
        case coverKey = "cover_i"
    }
}

final class ApiService {
    private let baseURL = "https://openlibrary.org/search.json"
    
    func fetchBooks(for userInput: String) async throws -> [BookDoc] {
        guard let url = URL(string: baseURL),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return [] }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: userInput),
            URLQueryItem(name: "limit", value: "10")
        ]
        guard let url = components.url else { return [] }
        
        var request = URLRequest(url: url)
        request.setValue("QuoteSaver (grudzien.mateusz00@gmail.com)", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return [] }
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(SearchResponse.self, from: data)
        
        return decodedResponse.docs ?? []
    }
}
