import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        BaseView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if viewModel.hasFullAccess {
                        buildSubInfoView
                    } else {
                        buildNoSubInfoView
                    }
                    
                    VStack(spacing: 16) {
                        buildToggleRow(label: "Settings_notifications", isOn: $viewModel.isNotificationsOn)
                        buildToggleRow(label: "Settings_analytics", isOn: $viewModel.isAnalyticsOn)
                        buildAboutUsButton
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        buildLinkButton(label: "Settings_policy") {
                            viewModel.openPrivacyPolicy()
                        }
                        
                        buildLinkButton(label: "Settings_write_to_us") {
                            viewModel.openMail()
                        }
                        
                        HStack(spacing: 3) {
                            QText("Settings_app_version", type: .regular, size: .vsmall)
                            QText(viewModel.appVersion, type: .regular, size: .vsmall)
                        }
                    }
                }
                .padding(.horizontal, 24)
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
        VStack(spacing: 16) {
            Image(.goldenCrown)
            VStack(spacing: 4) {
                QText("Settings_unlocked_header", type: .bold, size: .medium)
                QText("Settings_thanks", type: .regular, size: .small)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Rectangle().stroke(.accent, lineWidth: 3))
        .padding(.top, 30)
    }
    
    private var buildNoSubInfoView: some View {
        VStack(spacing: 16) {
            Image(.grayCrown)
            QText("Settings_upgrade_header", type: .bold, size: .medium)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 4) {
                buildPadlockInfo("Settings_padlock1")
                buildPadlockInfo("Settings_padlock2")
                buildPadlockInfo("Settings_padlock3")
            }
            
            Button {
                viewModel.showPaywall()
            } label: {
                QText("Settings_upgrade_now", type: .bold, size: .medium)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
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
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(.hint)
        }
    }
    
    private func buildPadlockInfo(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(.padlock)
            QText(text, type: .regular, size: .small)
        }
    }
    
    private func buildToggleRow(label: String , isOn: Binding<Bool>) -> some View {
        HStack {
            QText(label, type: .regular, size: .small)
            Toggle("", isOn: isOn)
                .tint(.accent)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 44)
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
