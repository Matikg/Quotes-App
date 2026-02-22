import SwiftUI

struct QBanner: View {
    private let title: String
    private let description: String
    private let action: () -> Void

    init(title: String, description: String, action: @escaping () -> Void) {
        self.title = title
        self.description = description
        self.action = action
    }

    var body: some View {
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
    }
}

#Preview {
    QBanner(title: "title", description: "description", action: {})
}
