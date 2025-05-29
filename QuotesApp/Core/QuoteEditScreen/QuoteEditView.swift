//
//  QuoteEditView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 03/08/2024.
//

import SwiftUI

struct QuoteEditView: View {
    @ObservedObject var viewModel: QuoteEditViewModel
    
    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    ZStack(alignment: .topTrailing) {
                        Button {
                            viewModel.scanQuote()
                        } label: {
                            HStack {
                                Image(systemName: "text.viewfinder")
                                QText("Scan_button_label", type: .regular, size: .vsmall)
                            }
                        }
                        
                        QInput(label: "Quote_label", text: $viewModel.quoteInput, type: .multiLine, error: viewModel.errors[.quote])
                    }
                    
                    buildBookButton()
                    
                    QInput(label: "Category_label", text: $viewModel.categoryInput, type: .oneLine, error: viewModel.errors[.category])
                    
                    QInput(label: "Page_label", text: $viewModel.pageInput, type: .oneLine, error: viewModel.errors[.page])
                        .keyboardType(.numberPad)
                    
                    QInput(label: "Note_label", text: $viewModel.noteInput, type: .multiLine)
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
    }
    
    //MARK: - View Builders
    
    @ViewBuilder
    private func buildBookButton() -> some View {
        VStack(alignment: .leading) {
            QText("Book_label", type: .bold, size: .vsmall)
            
            Button {
                viewModel.addBook()
            } label: {
                HStack {
                    QText(viewModel.bookButtonLabel, type: .regular, size: .vsmall)
                        .accentColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.accent)
                        .font(.system(size: 22))
                }
                .frame(height: 38)
                .padding(.horizontal, 10)
                .background(Rectangle().stroke(viewModel.errors[.book] == nil ? Color.accentColor : .red, lineWidth: 1))
            }
            if let error = viewModel.errors[.book] {
                QText(error, type: .regular, size: .vsmall)
                    .accentColor(.red)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

//#Preview {
//    QuoteEditView()
//}
