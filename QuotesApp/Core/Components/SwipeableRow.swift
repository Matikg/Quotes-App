//
//  SwipeableRow.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 19/03/2025.
//

import SwiftUI

struct SwipeableRow<Content: View>: View {
    private let content: () -> Content
    private let onDelete: () -> Void
    private let threshold: CGFloat = 50
    private let rowId: UUID
    @Binding private var activeRow: UUID?
    
    @State private var offset: CGFloat = 0
    
    init(
        rowId: UUID,
        activeRow: Binding<UUID?>,
        @ViewBuilder content: @escaping () -> Content,
        onDelete: @escaping () -> Void
    ) {
        self.rowId = rowId
        self._activeRow = activeRow
        self.content = content
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Button(action: {
                withAnimation {
                    offset = 0
                }
                onDelete()
            }) {
                ZStack {
                    Color.red
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .frame(width: 80)
            .contentShape(.rect)
            
            content()
                .padding(.horizontal)
                .background(Color.background)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                if activeRow != rowId {
                                    activeRow = rowId
                                }
                                offset = max(value.translation.width, -120)
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if -value.translation.width > threshold {
                                    offset = -120
                                } else {
                                    offset = 0
                                }
                            }
                        }
                )
                .onChange(of: activeRow) { _,  newValue in
                    if newValue != rowId && offset != 0 {
                        withAnimation {
                            offset = 0
                        }
                    }
                }
        }
    }
}
