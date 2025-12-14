import DependencyInjection
import Foundation

protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

final class BookApiService {
    @Injected private var crashlyticsManager: CrashlyticsManagerInterface

    private let baseURL: String
    private let session: NetworkSession

    init(baseURL: String = "https://openlibrary.org/search.json", session: NetworkSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchBooks(for userInput: String) async throws -> [BookDoc] {
        guard let url = URL(string: baseURL),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            let error = URLError(.badURL)
            crashlyticsManager.record(error)
            throw error
        }

        components.queryItems = [
            URLQueryItem(name: "q", value: userInput),
            URLQueryItem(name: "limit", value: "5")
        ]

        guard let url = components.url else {
            let error = URLError(.badURL)
            crashlyticsManager.record(error)
            throw error
        }

        var request = URLRequest(url: url)
        request.setValue("QuoteSaver (grudzien.mateusz00@gmail.com)", forHTTPHeaderField: "User-Agent")

        do {
            let (data, _) = try await session.data(for: request)
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(SearchResponse.self, from: data)

            return decodedResponse.docs ?? []
        } catch {
            crashlyticsManager.record(error)
            throw error
        }
    }

    func fetchBookCover(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue("QuoteSaver (grudzien.mateusz00@gmail.com)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           (200 ... 299).contains(httpResponse.statusCode)
        {
            return data
        } else {
            let error = URLError(.badServerResponse)
            crashlyticsManager.record(error)
            throw error
        }
    }
}
