import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    if viewModel.hasFullAccess {
                        buildSubInfoView
                    } else {
                        buildNoSubInfoView
                    }
                    
                    VStack(spacing: 15) {
                        buildToggleRow(label: "Settings_notifications", isOn: $viewModel.isNotificationsOn)
                        buildToggleRow(label: "Settings_analytics", isOn: $viewModel.isAnalyticsOn)
                        buildAboutUsButton
                    }
                    
                    VStack(spacing: 15) {
                        buildLinkButton(label: "Settings_policy") {
                            viewModel.openPrivacyPolicy()
                        }
                        
                        buildLinkButton(label: "Settings_write_to_us") {
                            viewModel.openMail()
                        }
                        
                        HStack {
                            QText("Settings_app_version", type: .regular, size: .vsmall)
                            QText(viewModel.appVersion, type: .regular, size: .vsmall)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navBar {
            QText("Settings", type: .bold, size: .medium)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    //MARK: - View Builders
    
    private var buildSubInfoView: some View {
        VStack(spacing: 20) {
            Image(.goldenCrown)
            QText("Settings_unlocked_header", type: .bold, size: .medium)
            QText("Settings_thanks", type: .regular, size: .small)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(Rectangle().stroke(.accent, lineWidth: 3))
        .padding(.top, 30)
    }
    
    private var buildNoSubInfoView: some View {
        VStack(spacing: 20) {
            Image(.grayCrown)
            QText("Settings_upgrade_header", type: .bold, size: .medium)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(.padlock)
                    QText("Settings_padlock1", type: .regular, size: .small)
                }
                HStack {
                    Image(.padlock)
                    QText("Settings_padlock2", type: .regular, size: .small)
                }
                HStack {
                    Image(.padlock)
                    QText("Settings_padlock3", type: .regular, size: .small)
                }
            }
            
            Button {
                viewModel.showPaywall()
            } label: {
                QText("Settings_upgrade_now", type: .bold, size: .medium)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(Rectangle().stroke(.accent, lineWidth: 3))
        .padding(.top, 30)
    }
    
    private var buildAboutUsButton: some View {
        Button {
            
        } label: {
            HStack {
                QText("Settings_about_us", type: .regular, size: .small)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.accent)
                    .font(.system(size: 22))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.hint)
        }
    }
    
    private func buildToggleRow(label: String , isOn: Binding<Bool>) -> some View {
        HStack {
            QText(label, type: .regular, size: .small)
            Toggle("", isOn: isOn)
                .tint(.accent)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.hint)
    }
    
    private func buildLinkButton(
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            QText(label, type: .regular, size: .small)
                .underline()
        }
    }
}

#Preview {
    SettingsView()
}
