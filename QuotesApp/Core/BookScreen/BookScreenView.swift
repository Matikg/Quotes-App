//
//  BookScreenView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 01/12/2024.
//

import SwiftUI

struct BookScreenView: View {
    @ObservedObject var viewModel = BookScreenViewModel()
    
    var body: some View {
        BackgroundStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    buildBookCover()
                    
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(spacing: 0) {
                            QInput(label: "Title_label", text: $viewModel.titleInput, type: .oneLine, error: viewModel.errors[.title])
                                .autocorrectionDisabled()
                                .onChange(of: viewModel.titleInput) { newValue in
                                    guard !newValue.isEmpty else {
                                        viewModel.foundBooks = []
                                        viewModel.didSelectSuggestion = false
                                        return
                                    }
                                    if viewModel.didSelectSuggestion {
                                        viewModel.didSelectSuggestion = false
                                        return
                                    }
                                    Task {
                                        try? await Task.sleep(nanoseconds: 300_000_000)
                                        if newValue == viewModel.titleInput {
                                            await viewModel.searchBooks()
                                        }
                                    }
                                }
                            
                            buildBookHint()
                        }
                        
                        QInput(label: "Author_label", text: $viewModel.authorInput, type: .oneLine, error: viewModel.errors[.author])
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                QText("BookScreen_title", type: .bold, size: .medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.saveBook()
                } label: {
                    Text("Save")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.background, for: .navigationBar)
    }
    
    //MARK: - View Builders
    
    @ViewBuilder
    private func buildBookCover() -> some View {
        if let coverURL = viewModel.coverURL {
            AsyncImage(url: coverURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 124, height: 169)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 124, height: 169)
                case .failure:
                    Image(.defaultBookCover)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 124, height: 169)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(.defaultBookCover)
                .resizable()
                .scaledToFill()
                .frame(width: 124, height: 169)
        }
    }
    
    @ViewBuilder
    private func buildBookHint() -> some View {
        if !viewModel.foundBooks.isEmpty, !viewModel.titleInput.isEmpty {
            VStack(spacing: 0) {
                ForEach(viewModel.foundBooks.prefix(3), id: \.title) { book in
                    QText("\(book.title ?? "No title"), \(book.authorName?.joined(separator: ", ") ?? "")", type: .bold, size: .vsmall)
                        .padding(.leading, 20)
                        .frame(height: 38)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("HintColor"))
                        .lineLimit(1)
                        .onTapGesture {
                            viewModel.selectBook(book)
                        }
                }
            }
        }
    }
}

#Preview {
    BookScreenView()
}
