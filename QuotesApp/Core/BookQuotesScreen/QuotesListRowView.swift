//
//  QuotesListRowView.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 09/03/2025.
//

import SwiftUI

struct QuotesListRowView: View {
    let quote: Domain.QuoteItem
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                Image(.quotationMark)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 24)
                
                Spacer()
                
                QText(quote.category, type: .regular, size: .vsmall)
                    .accentColor(.black)
                    .padding(5)
                    .background(Rectangle().stroke(Color.accentColor, lineWidth: 1))
            }
            
            QText(quote.text, type: .regular, size: .vsmall)
                .accentColor(.black)
                .lineLimit(3)
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                HStack {
                    QText("Quote_page_label", type: .italic, size: .vsmall)
                    QText(String(quote.page), type: .italic, size: .vsmall)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Spacer()
                    QText(
                        quote.date.formatted(.dateTime.day().month(.twoDigits).year()),
                        type: .italic,
                        size: .vsmall
                    )
                }
            }
            
            Divider()
        }
    }
}

#Preview {
    QuotesListRowView(quote: Domain.QuoteItem(id: UUID(), text: "The work that hurts you less than it hurts others is the work you were made to do.", page: 21, category: "productivity", date: .now, note: ""))
}
