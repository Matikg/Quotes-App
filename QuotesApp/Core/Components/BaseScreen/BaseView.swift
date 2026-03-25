import SwiftUI

struct BaseView<Content: View>: View {
    private let backgroundColor = Color.background
    private let content: () -> Content

    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                content()
                Spacer()
            }
        }
    }
}

extension BaseView {
    func navBar() -> some View {
        modifier(NativeNavigationBarModifier())
    }

    func navBar(
        leading navbarLeading: @escaping () -> some View
    ) -> some View {
        modifier(
            NativeNavigationBarModifier(
                leading: AnyView(navbarLeading())
            )
        )
    }

    func navBar(
        trailing navbarTrailing: @escaping () -> some View
    ) -> some View {
        modifier(
            NativeNavigationBarModifier(
                trailing: AnyView(navbarTrailing())
            )
        )
    }

    func navBarTitle(_ titleKey: String) -> some View {
        modifier(NativeNavigationBarModifier(titleKey: titleKey))
    }

    func navBarTitle(
        _ titleKey: String,
        leading navbarLeading: @escaping () -> some View
    ) -> some View {
        modifier(
            NativeNavigationBarModifier(
                titleKey: titleKey,
                leading: AnyView(navbarLeading())
            )
        )
    }

    func navBarTitle(
        _ titleKey: String,
        trailing navbarTrailing: @escaping () -> some View
    ) -> some View {
        modifier(
            NativeNavigationBarModifier(
                titleKey: titleKey,
                trailing: AnyView(navbarTrailing())
            )
        )
    }

    func navBarTitle(
        _ titleKey: String,
        leading navbarLeading: @escaping () -> some View,
        trailing navbarTrailing: @escaping () -> some View
    ) -> some View {
        modifier(
            NativeNavigationBarModifier(
                titleKey: titleKey,
                leading: AnyView(navbarLeading()),
                trailing: AnyView(navbarTrailing())
            )
        )
    }
}

private struct NativeNavigationBarModifier: ViewModifier {
    let titleKey: String?
    let leading: AnyView?
    let trailing: AnyView?

    init(
        titleKey: String? = nil,
        leading: AnyView? = nil,
        trailing: AnyView? = nil
    ) {
        self.titleKey = titleKey
        self.leading = leading
        self.trailing = trailing
    }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(leading != nil)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(NavigationTitleModifier(titleKey: titleKey))
            .toolbar {
                if let titleKey {
                    ToolbarItem(placement: .principal) {
                        QText(titleKey, type: .bold, size: .medium)
                            .lineLimit(1)
                    }
                }

                if let leading {
                    ToolbarItem(placement: .topBarLeading) {
                        leading
                    }
                }

                if let trailing {
                    ToolbarItem(placement: .topBarTrailing) {
                        trailing
                    }
                }
            }
    }
}

private struct NavigationTitleModifier: ViewModifier {
    let titleKey: String?

    func body(content: Content) -> some View {
        if let titleKey {
            content.navigationTitle(LocalizedStringKey(titleKey))
        } else {
            content
        }
    }
}
