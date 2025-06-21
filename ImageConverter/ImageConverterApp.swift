import SwiftUI


@main
struct ImageConverterApp: App {
    @StateObject private var settingsStore = SettingsStore()
    

    var body: some Scene {
        MenuBarExtra("Image Converter", systemImage: "photo.on.rectangle") {
            AppMenu()
                .environmentObject(settingsStore)
        }
        
        Settings {
            SettingsView()
                .environmentObject(settingsStore)
        }
    }
}
