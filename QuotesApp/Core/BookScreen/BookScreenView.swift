import PhotosUI
import SwiftUI

struct BookScreenView: View {
    @StateObject var viewModel = BookScreenViewModel()
    @State private var selectedCoverItem: PhotosPickerItem?

    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    buildBookCover()

                    VStack(alignment: .leading, spacing: 30) {
                        VStack(spacing: 0) {
                            QInput(
                                label: "input_label_title",
                                text: $viewModel.titleInput,
                                type: .oneLine,
                                isLoading: viewModel.isSearching,
                                error: viewModel.errors[.title]
                            )
                            .autocorrectionDisabled()

                            buildBookHint()
                        }

                        QInput(
                            label: "input_label_author",
                            text: $viewModel.authorInput,
                            type: .oneLine,
                            error: viewModel.errors[.author]
                        )
                        .autocorrectionDisabled()
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navBarTitle("book_screen_navigation_title", leading: {
            Button {
                viewModel.dismissBookScreen()
            } label: {
                Image(systemName: "xmark")
            }
        }, trailing: {
            Button {
                viewModel.saveBook()
            } label: {
                Text("nav_bar_button_save")
            }
        })
    }

    // MARK: - View Builders

    private func buildBookCover() -> some View {
        ZStack(alignment: .bottomTrailing) {
            switch viewModel.coverImage {
            case .default:
                DefaultBookCover()
            case .loading:
                ProgressView()
                    .tint(.accent)
                    .frame(width: 124, height: 169)
            case let .image(data):
                if let uiImage = UIImage(data: data) {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 124, height: 169)

                        Button(action: {
                            viewModel.resetCover()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.accent)
                                .padding(4)
                                .background(Color.background)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .offset(x: 0, y: -8)
                    }
                } else {
                    DefaultBookCover()
                }
            }

            PhotosPicker(selection: $selectedCoverItem, matching: .images) {
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.background)
                    .frame(width: 32, height: 32)
                    .background(Color.accent)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
            }
            .offset(x: 8, y: 8)
        }
        .onChange(of: selectedCoverItem) { _, newValue in
            guard let newValue else { return }
            Task {
                await viewModel.handleCoverSelection(newValue)
                await MainActor.run {
                    selectedCoverItem = nil
                }
            }
        }
    }

    @ViewBuilder
    private func buildBookHint() -> some View {
        if !viewModel.foundBooks.isEmpty, !viewModel.titleInput.isEmpty {
            VStack(spacing: 0) {
                ForEach(viewModel.foundBooks.prefix(3)) { book in
                    QText("\(book.title), \(book.author)", type: .bold, size: .vsmall)
                        .padding(.leading, 20)
                        .frame(height: 38)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.hint)
                        .lineLimit(1)
                        .onTapGesture {
                            viewModel.selectBook(book)
                        }
                }
            }
        }
    }
}
