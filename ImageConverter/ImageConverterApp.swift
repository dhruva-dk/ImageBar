import SwiftUI
import MenuBarExtraAccess


@main
struct ImageConverterApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State var isMenuPresented: Bool = false
    

    var body: some Scene {
        MenuBarExtra("Image Converter", systemImage: "photo.on.rectangle") {
            AppMenu()
                .environmentObject(settingsViewModel)

        }

        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in // <-- the magic ✨
             // access status item or store it in a @State var
        }
        
        Settings {
            SettingsView()
                .environmentObject(settingsViewModel)
        }
    }
}
