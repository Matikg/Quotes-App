import Foundation
@testable import QuotesApp

class MockNetworkSession: NetworkSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        guard let data, let response else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
