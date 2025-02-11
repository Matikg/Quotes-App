import XCTest
@testable import QuotesApp

final class ApiServiceTests: XCTestCase {
    func testFetchBooksReturnsBooksOnValidResponse() async throws {
        // Given
        let mockSession = MockNetworkSession()
        let expectedBooks = [
            BookDoc(title: "Book 1", authorName: [], coverEditionKey: nil, coverKey: nil),
            BookDoc(title: "Book 2", authorName: ["name"], coverEditionKey: "edition key", coverKey: 1)
        ]
        let mockResponse = SearchResponse(numFound: 2, docs: expectedBooks)
        let responseData = try! JSONEncoder().encode(mockResponse)
        
        mockSession.data = responseData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://openlibrary.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let apiService = BookApiService(session: mockSession)
        
        // When
        let books = try await apiService.fetchBooks(for: "Swift")
        
        // Then
        XCTAssertEqual(books.count, expectedBooks.count)
        XCTAssertEqual(books.first?.title, expectedBooks.first?.title)
    }

    func testFetchBooksReturnsEmptyOnInvalidResponse() async throws {
        // Given
        let mockSession = MockNetworkSession()
        let mockResponse = SearchResponse(numFound: 2, docs: [])
        let responseData = try! JSONEncoder().encode(mockResponse)
        
        mockSession.data = responseData
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://openlibrary.org")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let apiService = BookApiService(session: mockSession)
        
        // When
        let books = try await apiService.fetchBooks(for: "Invalid")
        
        // Then
        XCTAssertTrue(books.isEmpty)
    }

    func testFetchBooksThrowsErrorOnNetworkFailure() async throws {
        // Given
        let mockSession = MockNetworkSession()
        mockSession.error = URLError(.notConnectedToInternet)
        
        let apiService = BookApiService(session: mockSession)
        
        do {
            // When
            _ = try await apiService.fetchBooks(for: "Error")
            XCTFail("Expected error to be thrown, but none was thrown.")
        } catch {
            // Then
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
}
