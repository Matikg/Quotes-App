import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel

    var body: some View {
        BaseView {
            VStack {
                switch viewModel.state {
                case .empty:
                    buildEmptyListView()

                case let .loaded(books):
                    buildLoadedListView(books: books)
                }
            }
            .onAppear {
                viewModel.getBooks()
            }
        }
        .navBar(
            center: {
                QText("Books_title", type: .bold, size: .medium)
            },
            trailing: {
                Button {
                    viewModel.openSettings()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                }
            }
        )
    }

    // MARK: - View Builders

    private func buildEmptyListView() -> some View {
        VStack {
            Spacer()
            Image(.bookshelf)
                .padding(.bottom, 30)

            QText("MainScreen_empty_quote", type: .bold, size: .medium)

            QButton(label: "Button_add_quote", state: viewModel.buttonState) {
                viewModel.addQuote()
            }

            Spacer()
        }
    }

    private func buildLoadedListView(books: [Domain.BookItem]) -> some View {
        VStack {
            BookListView(
                books: books,
                showQuotesNumber: true
            ) { selectedBook in
                viewModel.selectBook(selectedBook)
            } onBookDeleted: { book in
                viewModel.bookToDelete = book
            }
            .refreshable {
                viewModel.getBooks()
            }

            QButton(label: "Button_add_quote", state: viewModel.buttonState) {
                viewModel.addQuote()
            }
        }
        .alert(item: $viewModel.bookToDelete) { book in
            Alert(
                title: Text("Book_delete_alert"),
                message: Text("Book_delete_message_alert"),
                primaryButton: .destructive(Text("Book_delete_alert"), action: {
                    viewModel.deleteBook(book)
                }),
                secondaryButton: .cancel {
                    viewModel.cancelDeleteBook()
                }
            )
        }
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
