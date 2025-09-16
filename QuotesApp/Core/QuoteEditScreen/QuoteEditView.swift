//
//  QuoteEditView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import SwiftUI

struct QuoteEditView: View {
    @ObservedObject var viewModel: QuoteEditViewModel
    @FocusState private var isCategoryFocused: Bool
    
    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    ZStack(alignment: .topTrailing) {
                        Button {
                            Task {
                                await viewModel.scanQuote()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "text.viewfinder")
                                QText("Scan_button_label", type: .regular, size: .vsmall)
                            }
                        }
                        
                        QInput(
                            label: "Quote_label",
                            text: $viewModel.quoteInput,
                            type: .multiLine,
                            error: viewModel.errors[.quote]
                        )
                    }
                    
                    bookButton
                    
                    VStack(spacing: 0) {
                        QInput(
                            label: "Category_label",
                            text: $viewModel.categoryInput,
                            type: .oneLine,
                            error: viewModel.errors[.category]
                        )
                        .focused($isCategoryFocused)
                        .onChange(of: isCategoryFocused) {
                            viewModel.isCategoryFocused = isCategoryFocused
                        }
                        
                        categoryHintScrollView
                    }
                    
                    QInput(
                        label: "Page_label",
                        text: $viewModel.pageInput,
                        type: .oneLine,
                        error: viewModel.errors[.page]
                    ).keyboardType(.numberPad)
                    
                    QInput(
                        label: "Note_label",
                        text: $viewModel.noteInput,
                        type: .multiLine
                    )
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navBar(
            center: {
                QText("QuoteEdit_title", type: .bold, size: .medium)
            },
            trailing: {
                Button {
                    viewModel.saveQuote()
                } label: {
                    QText("Save", type: .regular, size: .small)
                }
            }
        )
        .alert("Camera_access_title",
               isPresented: $viewModel.showCameraAccessAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Settings") {
                viewModel.openAppSettings()
            }
        } message: {
            Text("Camera_access_description")
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    //MARK: - View Builders
    
    @ViewBuilder
    private var categoryHintScrollView: some View {
        if !viewModel.isCategoryFocused { EmptyView() } else {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(viewModel.categoriesHint, id: \.self) { category in
                        QText(category, type: .bold, size: .vsmall)
                            .padding(.horizontal, 20)
                            .frame(height: 38)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.hint)
                            .lineLimit(1)
                            .onTapGesture {
                                viewModel.selectCategory(category)
                            }
                    }
                }
            }
            .frame(maxHeight: 76)
        }
    }
    
    @ViewBuilder
    private var bookButton: some View {
        VStack(alignment: .leading) {
            QText("Book_label", type: .bold, size: .vsmall)
            
            Button {
                viewModel.addBook()
            } label: {
                HStack {
                    QText(viewModel.bookButtonLabel, type: .regular, size: .vsmall)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.accent)
                        .font(.system(size: 22))
                }
                .frame(height: 38)
                .padding(.horizontal, 10)
                .background(Rectangle().stroke(viewModel.errors[.book] == nil ? .accent : .red, lineWidth: 1))
            }
            if let error = viewModel.errors[.book] {
                QText(error, type: .regular, size: .vsmall)
                    .accentColor(.red)
            }
        }
    }
}
