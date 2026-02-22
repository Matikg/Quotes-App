import SwiftUI

struct DefaultBookCover: View {
    var body: some View {
        Image(.defaultBookCover)
            .resizable()
            .frame(width: 124, height: 169)
    }
}

#Preview {
    DefaultBookCover()
}
