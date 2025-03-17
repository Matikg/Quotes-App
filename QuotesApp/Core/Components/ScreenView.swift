import SwiftUI

struct ScreenView<Content: View>: View {
    private let backgroundColor = Color.background
    private let content: () -> Content
    private var navbar: AnyView? = nil
    private var navbarTrailing: AnyView? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    private var showBackButton: Bool {
        presentationMode.wrappedValue.isPresented
    }
    
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
                            if showBackButton {
                                Button(action: { dismiss() }) {
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

extension ScreenView {
    func navBar<NavBar: View>(_ navbar: @escaping () -> NavBar) -> ScreenView {
        ScreenView(
            navbar: AnyView(navbar()),
            navbarTrailing: nil,
            content: content
        )
    }
    
    func navBar<NavBar: View, NavBarTrailing: View>(
        center navbar: @escaping () -> NavBar,
        trailing navbarTrailing: @escaping () -> NavBarTrailing
    ) -> ScreenView {
        ScreenView(
            navbar: AnyView(navbar()),
            navbarTrailing: AnyView(navbarTrailing()),
            content: content
        )
    }
}
