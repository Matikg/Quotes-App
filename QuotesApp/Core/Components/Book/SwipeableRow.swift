import SwiftUI

struct SwipeableRow<Content: View>: View {
    private let content: () -> Content
    private let onDelete: () -> Void
    private let swipeThreshold: CGFloat = 50
    private let maxSwipeOffset: CGFloat = -120
    private let rowId: UUID

    @Binding private var activeRow: UUID?
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var hasActivatedRow = false

    init(
        rowId: UUID,
        activeRow: Binding<UUID?>,
        @ViewBuilder content: @escaping () -> Content,
        onDelete: @escaping () -> Void
    ) {
        self.rowId = rowId
        _activeRow = activeRow
        self.content = content
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            deleteButton

            content()
                .padding(.horizontal)
                .background(Color.background)
                .offset(x: offset)
                .gesture(dragGesture)
                .onChange(of: activeRow) { _, newValue in
                    if newValue != rowId, offset != 0 {
                        resetOffset()
                    }
                }
        }
        .animation(isDragging ? nil : .interactiveSpring(response: 0.3, dampingFraction: 0.8), value: offset)
    }

    private var deleteButton: some View {
        Button(action: handleDelete) {
            ZStack {
                Color.red
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .frame(width: 80)
        .contentShape(.rect)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged { value in
                let newOffset = min(0, max(value.translation.width, maxSwipeOffset))
                offset = newOffset

                if newOffset < 0, activeRow != rowId {
                    activeRow = rowId
                }
            }
            .onEnded { value in
                withAnimation(.spring()) {
                    if value.translation.width < -swipeThreshold || value.predictedEndTranslation.width < -swipeThreshold {
                        offset = maxSwipeOffset
                    } else {
                        resetOffset()
                    }
                }
            }
    }

    private func handleDelete() {
        withAnimation {
            resetOffset()
        }
        onDelete()
    }

    private func resetOffset() {
        offset = 0
    }
}
