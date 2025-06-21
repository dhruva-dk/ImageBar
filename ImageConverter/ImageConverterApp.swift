import SwiftUI


@main
struct ImageConverterApp: App {
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var appController = AppController()
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            AppMenu()
                .environmentObject(settingsStore)
                .environmentObject(appController)
        } label: {
            let icon = NSImage(systemSymbolName: "photo.on.rectangle.angled", accessibilityDescription: "Image Converter")!
            let imageView = NSImageView(image: icon)
            
            appDelegate.configure(statusItem: imageView.superview?.superview as? NSStatusItem, with: appController)
            
            return imageView
        }
        
        Settings {
            SettingsView()
                .environmentObject(settingsStore)
        }
    }
}
