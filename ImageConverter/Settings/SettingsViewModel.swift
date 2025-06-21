import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var outputFormat: Int {
        didSet {
            UserDefaults.standard.set(outputFormat, forKey: "outputFormat")
        }
    }
    
    @Published var outputSize: Int {
        didSet {
            UserDefaults.standard.set(outputSize, forKey: "outputSize")
        }
    }

    init() {
        self.outputFormat = UserDefaults.standard.integer(forKey: "outputFormat")
        let savedSize = UserDefaults.standard.integer(forKey: "outputSize")
        self.outputSize = savedSize == 0 ? 1200 : savedSize
    }
}
