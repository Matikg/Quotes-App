//
//  ApiService.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import Foundation

final class ApiService {
    private let baseURL = "https://openlibrary.org/search.json"
    
    func fetchBooks(for userInput: String) async throws -> [BookDoc] {
        guard let url = URL(string: baseURL),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return [] }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: userInput),
            URLQueryItem(name: "limit", value: "3")
        ]
        guard let url = components.url else { return [] }
        
        var request = URLRequest(url: url)
        request.setValue("QuoteSaver (grudzien.mateusz00@gmail.com)", forHTTPHeaderField: "User-Agent")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(SearchResponse.self, from: data)
        
        return decodedResponse.docs ?? []
    }
}
