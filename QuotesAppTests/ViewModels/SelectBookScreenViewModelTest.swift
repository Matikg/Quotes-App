import XCTest
@testable import QuotesApp
import SwiftUI
import DependencyInjection

class DummyBookEntity: BookEntity { }

private final class MockCoreDataManager: CoreDataManagerInterface {
    private(set) var fetchBooksCalled = false
    
    var booksToReturn: [BookEntity] = []
    
    func fetchBooks() -> [BookEntity] {
        fetchBooksCalled = true
        return booksToReturn
    }
    
    func fetchBookEntity(for domainBook: Domain.BookItem) -> BookEntity? { nil }
    func saveQuote(
        to book: BookEntity,
        text: String,
        category: String,
        page: Int,
        note: String,
        quoteId: UUID?
    ) { }
    func deleteBook(book: Domain.BookItem) { }
    func deleteQuote(quote: Domain.QuoteItem) { }
    func saveBook(for book: Domain.BookItem) { }
    func fetchQuotes(for selectedBook: Domain.BookItem) -> [QuoteEntity] { [] }
    func fetchBook(for quote: Domain.QuoteItem) -> BookEntity? { nil }
    func fetchAllQuotes() -> [QuoteEntity] { [] }
}

private final class MockNavigationRouter: NavigationRouting {
    @Published var path: NavigationPath = .init()
    @Published var presentedSheet: Route? = nil
    
    private(set) var lastPushedRoute: Route? = nil
    
    private(set) var popCalled = false
    
    func push(route: Route) {
        lastPushedRoute = route
    }
    func pop() {
        popCalled = true
    }
    func popAll() { }
    func set(navigationStack: NavigationPath) { }
    func present(sheet: Route) { }
}

private final class MockSaveQuoteRepository: SaveQuoteRepositoryInterface {
    private(set) var selectBookCalledWith: Domain.BookItem? = nil
    
    private(set) var _selectedBook: Domain.BookItem? = nil
    var selectedBook: Domain.BookItem? { _selectedBook }
    
    func selectBook(_ book: Domain.BookItem) {
        selectBookCalledWith = book
        _selectedBook = book
    }
    
    func saveBook(_ book: Domain.BookItem) { }
    
    func resetBook() {
        _selectedBook = nil
    }
}

// MARK: - Tests

final class SelectBookScreenViewModelTests: XCTestCase {
    
    // our mocks:
    private var mockCoreDataManager: MockCoreDataManager!
    private var mockNavigationRouter: MockNavigationRouter!
    private var mockSaveQuoteRepo: MockSaveQuoteRepository!
    
    // System under test
    private var sut: SelectBookScreenViewModel!
    
    override func setUp() {
        super.setUp()
        
        // 1) Make new instances of each mock
        mockCoreDataManager = MockCoreDataManager()
        mockNavigationRouter = MockNavigationRouter()
        mockSaveQuoteRepo = MockSaveQuoteRepository()
        
        // TODO: Register all dependencies:
//        DependencyInjection.register(CoreDataManagerInterface.self) { _ in
//            return self.mockCoreDataManager
//        }
//        DependencyInjection.register(NavigationRouting.self) { _ in
//            return self.mockNavigationRouter
//        }
//        DependencyInjection.register(SaveQuoteRepositoryInterface.self) { _ in
//            return self.mockSaveQuoteRepo
//        }
        
        // 3) Now that DI is wired up, create a fresh ViewModel.
        sut = SelectBookScreenViewModel()
    }
    
    override func tearDown() {
        // TODO: Reset all dependencies and nil everything
//        DependencyInjection.reset(CoreDataManagerInterface.self)
//        DependencyInjection.reset(NavigationRouting.self)
//        DependencyInjection.reset(SaveQuoteRepositoryInterface.self)
        
        mockCoreDataManager = nil
        mockNavigationRouter = nil
        mockSaveQuoteRepo = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_createBook_pushesBookRoute() {
        // When
        sut.createBook()
        
        // Then
        XCTAssertEqual(
            mockNavigationRouter.lastPushedRoute,
            .book
        )
    }
    
    func test_selectBook_callsSaveQuoteAndPops() {
        // Given
        // TODO: Create stub for book object
        let dummyBook = Domain.BookItem(id: UUID(), title: "", author: "", quotesNumber: 1, coverImageData: nil)
        
        // When
        sut.selectBook(book: dummyBook)
        
        // Then
        XCTAssertEqual(
            mockSaveQuoteRepo.selectBookCalledWith,
            dummyBook
        )
        XCTAssertTrue(mockNavigationRouter.popCalled)
    }
    
    // TODO: test onAppear
}
