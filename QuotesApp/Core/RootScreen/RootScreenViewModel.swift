import SwiftUI

final class RootScreenViewModel: ObservableObject {
    @AppStorage(UserDefaultsConstants.FirstLaunchKey) var isFirstLaunch: Bool = true
    let mainScreenViewModel = MainScreenViewModel()
}
