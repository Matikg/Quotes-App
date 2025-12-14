import DependencyInjection
import SwiftUI

struct BaseView<Content: View>: View {
    @StateObject private var viewModel = BaseViewModel()

    private let backgroundColor = Color.background
    private let content: () -> Content
    private var navbar: AnyView?
    private var navbarTrailing: AnyView?

    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    private init(
        navbar: AnyView?,
        navbarTrailing: AnyView?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navbar = navbar
        self.navbarTrailing = navbarTrailing
        self.content = content
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if let navbar {
                    ZStack(alignment: .top) {
                        HStack {
                            if viewModel.showBackButton {
                                Button(action: { viewModel.navigateBack() }) {
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.accent)
                                            .padding(.leading, 16)
                                        QText("Back", type: .regular, size: .small)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }

                            Spacer()

                            navbarTrailing
                                .padding(.trailing, 16)
                        }

                        navbar
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 100)
                    }
                    .background(Color.background)
                    .padding(.vertical, 8)
                }

                content()

                Spacer()
            }
        }
        .toolbar(.hidden)
    }
}

extension BaseView {
    func navBar(_ navbar: @escaping () -> some View) -> BaseView {
        BaseView(
            navbar: AnyView(navbar()),
            navbarTrailing: nil,
            content: content
        )
    }

    func navBar(
        center navbar: @escaping () -> some View,
        trailing navbarTrailing: @escaping () -> some View
    ) -> BaseView {
        BaseView(
            navbar: AnyView(navbar()),
            navbarTrailing: AnyView(navbarTrailing()),
            content: content
        )
    }
}
