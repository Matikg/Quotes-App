//
//  ApiService.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import Foundation

protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request, delegate: nil)
    }
}

final class ApiService {
    private let baseURL: String
    private let session: NetworkSession

    init(baseURL: String = "https://openlibrary.org/search.json", session: NetworkSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchBooks(for userInput: String) async throws -> [BookDoc] {
        guard let url = URL(string: baseURL),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return [] }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: userInput),
            URLQueryItem(name: "limit", value: "5")
        ]
        guard let url = components.url else { return [] }
        
        var request = URLRequest(url: url)
        request.setValue("QuoteSaver (grudzien.mateusz00@gmail.com)", forHTTPHeaderField: "User-Agent")
        
        let (data, _) = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(SearchResponse.self, from: data)
        
        return decodedResponse.docs ?? []
    }
}
