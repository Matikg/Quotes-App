import SwiftUI

struct WhatsNewView: View {
    @StateObject private var viewModel = WhatsNewViewModel()

    var body: some View {
        BaseView {
            Group {
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(.accent)
                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            QText(viewModel.title, type: .bold, size: .large)
                                .frame(maxWidth: .infinity, alignment: .center)

                            HStack(spacing: 4) {
                                QText("update_info_app_version", type: .regular, size: .medium)
                                QText(viewModel.appVersion, type: .bold, size: .medium)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                            QText(viewModel.description, type: .regular, size: .medium)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    }
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    WhatsNewView()
}
