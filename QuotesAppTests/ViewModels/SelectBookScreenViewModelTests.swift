import DependencyInjection
@testable import QuotesApp
import XCTest

final class SelectBookScreenViewModelTests: XCTestCase {
    private var mockCoreDataManager: MockCoreDataManager!
    private var mockNavigationRouter: MockNavigationRouter!
    private var mockSaveQuoteRepo: MockSaveQuoteRepository!

    private var sut: SelectBookScreenViewModel!

    override func setUp() {
        super.setUp()

        // 1) Make new instances of each mock
        mockCoreDataManager = MockCoreDataManager()
        mockNavigationRouter = MockNavigationRouter()
        mockSaveQuoteRepo = MockSaveQuoteRepository()

        // 2) Register all dependecies
        let container = ContainerManager.shared.container(for: .main)
        container.reset()

        container.register(CoreDataManagerInterface.self, instance: mockCoreDataManager)
        container.register((any NavigationRouting).self, instance: mockNavigationRouter)
        container.register(SaveQuoteRepositoryInterface.self, instance: mockSaveQuoteRepo)

        // 3) Now that DI is wired up, create a fresh ViewModel
        sut = SelectBookScreenViewModel()
    }

    override func tearDown() {
        ContainerManager.shared.removeContainer(for: .main)

        mockCoreDataManager = nil
        mockNavigationRouter = nil
        mockSaveQuoteRepo = nil
        sut = nil

        super.tearDown()
    }

    @MainActor
    func test_createBook_pushesBookRoute() {
        // When
        sut.createBook()

        // Then
        XCTAssertEqual(mockNavigationRouter.lastPushedRoute, .book)
    }

    func test_selectBook_callsSaveQuoteAndPops() {
        // Given
        let dummyBook = BookItemStub.make(title: "Stub Book")

        // When
        sut.selectBook(book: dummyBook)

        // Then
        XCTAssertEqual(mockSaveQuoteRepo.selectBookCalledWith, dummyBook)
        XCTAssertEqual(mockNavigationRouter.popCallCount, 1)
    }

    func test_onAppear_fetchesAndMapsBooks() {
        // Given
        let book1 = BookEntityStub.make(
            id: UUID(),
            title: "Book 1",
            author: "Author A",
        )
        let book2 = BookEntityStub.make(
            id: UUID(),
            title: "Book 2",
            author: "Author B",
        )

        mockCoreDataManager.booksToReturn = [book1, book2]

        // Sanity
        XCTAssertFalse(mockCoreDataManager.fetchBooksCalled)
        XCTAssertTrue(sut.books.isEmpty)

        // When
        sut.onAppear()

        // Then
        XCTAssertEqual(mockCoreDataManager.fetchBooksCallsCount, 1)
        XCTAssertEqual(sut.books.count, 2)

        let expected = [book1, book2].compactMap(Domain.BookItem.init)
        XCTAssertEqual(sut.books, expected)
    }
}
