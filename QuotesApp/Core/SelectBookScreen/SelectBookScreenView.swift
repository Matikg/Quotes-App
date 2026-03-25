import SwiftUI

struct SelectBookScreenView: View {
    @StateObject var viewModel = SelectBookScreenViewModel()

    var body: some View {
        BaseView {
            BookListView(books: viewModel.books, showQuotesNumber: false) { book in
                viewModel.selectBook(book: book)
            } onBookDeleted: { _ in }
                .onAppear { viewModel.onAppear() }
                .padding(.horizontal)
        }
        .navBarTitle("book_select_screen_navigation_title", trailing: {
            Button {
                Task { await viewModel.createBook() }
            } label: {
                Text("nav_bar_button_create")
            }
        })
    }
}

#Preview {
    SelectBookScreenView()
}
