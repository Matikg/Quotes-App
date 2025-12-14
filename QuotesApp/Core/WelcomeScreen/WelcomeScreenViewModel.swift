import SwiftUI

final class WelcomeScreenViewModel: ObservableObject {
    func ctaButtonTapped() {
        UserDefaults.standard.setValue(false, forKey: UserDefaultsConstants.FirstLaunchKey)
    }
}
