import SwiftUI


@main
struct ImageConverterApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    

    var body: some Scene {
        MenuBarExtra("Image Converter", systemImage: "photo.on.rectangle") {
            AppMenu()
                .environmentObject(settingsViewModel)
        }
        
        Settings {
            SettingsView()
                .environmentObject(settingsViewModel)
        }
    }
}
