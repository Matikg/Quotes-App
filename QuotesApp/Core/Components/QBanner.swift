import SwiftUI

struct QBanner: View {
    private let title: String
    private let description: String
    private let action: () -> Void
    private let onClose: () -> Void

    init(
        title: String,
        description: String,
        action: @escaping () -> Void,
        onClose: @escaping () -> Void = {}
    ) {
        self.title = title
        self.description = description
        self.action = action
        self.onClose = onClose
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 8) {
                    QText(title, type: .bold, size: .vsmall)
                    QText(description, type: .regular, size: .vsmall)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(.hint)
            }
            .buttonStyle(.plain)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.accent)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(Color.clear.contentShape(Rectangle()))
            .zIndex(1)
            .padding(.top, 8)
            .padding(.trailing, 8)
        }
    }
}

#Preview {
    QBanner(title: "title", description: "description", action: {})
}
