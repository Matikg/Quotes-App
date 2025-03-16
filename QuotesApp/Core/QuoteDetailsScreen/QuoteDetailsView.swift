//
//  QuoteDetailsView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 14/03/2025.
//

import SwiftUI

struct QuoteDetailsView: View {
    @ObservedObject var viewModel: QuoteDetailsViewModel
    
    var body: some View {
        ScreenView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    HStack(alignment: .top) {
                        quotationMark
                        
                        Spacer()
                        
                        quoteCategory
                    }
                    
                    quoteText
                    
                    ZStack {
                        quotePage
                        
                        HStack {
                            Spacer()
                            quoteDate
                        }
                    }
                    
                    personalNote
                }
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 30)
            }
        }
        .navBar(center: {
            VStack(spacing: 8) {
                QText(viewModel.book?.title ?? "", type: .bold, size: .medium)
                    .lineLimit(1)
                QText(viewModel.book?.author ?? "", type: .regular, size: .vsmall)
            }
        }, trailing: {
            Button {
                viewModel.editQuote()
            } label: {
                QText("Edit", type: .regular, size: .small)
            }
        })
    }
    
    //MARK: - View Builders
    
    private var quotationMark: some View {
        Image(.quotationMark)
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 24)
    }
    
    private var quoteCategory: some View {
        QText(viewModel.quote.category, type: .regular, size: .vsmall)
            .accentColor(.black)
            .padding(5)
            .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
    }
    
    private var quoteText: some View {
        QText(viewModel.quote.text, type: .regular, size: .vsmall)
            .accentColor(.black)
            .lineSpacing(10)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var quotePage: some View {
        HStack {
            QText("Quote_page_label", type: .italic, size: .vsmall)
            QText(String(viewModel.quote.page), type: .italic, size: .vsmall)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var quoteDate: some View {
        QText(
            viewModel.quote.date.formatted(.dateTime.day().month(.twoDigits).year()),
            type: .italic,
            size: .vsmall
        )
    }
    
    @ViewBuilder
    private var personalNote: some View {
        if !viewModel.quote.note.isEmpty {
            VStack(alignment: .leading, spacing: 15) {
                QText("Note_label", type: .bold, size: .vsmall)
                
                QText(viewModel.quote.note, type: .regular, size: .vsmall)
                    .accentColor(.black)
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    QuoteDetailsView(viewModel: QuoteDetailsViewModel(quote: .init(id: UUID(), text: "Hello world!", page: 1, category: "productivity", date: Date(), note: "")))
}
