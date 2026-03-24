import SwiftUI

struct WelcomeScreenView: View {
    @ObservedObject var viewModel: WelcomeScreenViewModel

    var body: some View {
        BaseView {
            VStack {
                Image(.book)

                QText("welcome_screen_title", type: .bold, size: .large)
                    .padding(.bottom)

                QText("welcome_screen_subtitle", type: .regular, size: .medium)

                QDivider()

                buildDescriptionView()

                Spacer()

                QText("welcome_screen_cta", type: .bold, size: .small)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)

                QButton(label: "button_let's_go", action: {
                    viewModel.ctaButtonTapped()
                })
            }
            .padding()
        }
    }

    private func buildDescriptionView() -> some View {
        VStack(spacing: 30) {
            QText("welcome_screen_describtion", type: .regular, size: .small)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 15) {
                QText("welcome_screen_detail1", type: .regular, size: .small)
                QText("welcome_screen_detail2", type: .regular, size: .small)
                QText("welcome_screen_detail3", type: .regular, size: .small)
            }
        }
    }
}

#Preview {
    WelcomeScreenView(viewModel: WelcomeScreenViewModel())
}
