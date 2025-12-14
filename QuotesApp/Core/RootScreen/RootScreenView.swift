import SwiftUI

struct RootScreenView: View {
    @ObservedObject var viewModel: RootScreenViewModel

    var body: some View {
        if viewModel.isFirstLaunch {
            WelcomeScreenView(viewModel: WelcomeScreenViewModel())
        } else {
            MainScreenView(viewModel: viewModel.mainScreenViewModel)
        }
    }
}

#Preview {
    RootScreenView(viewModel: RootScreenViewModel())
}
