import SwiftUI

struct AppMenu: View {

    @State private var importing = false

    var body: some View {
        
        
        
        // MARK: File Selection Button
        
        Button( "Select Images") {
            self.importing = true
        }
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: [.image],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let files):
                for file in files {
                    print(file.absoluteString)
                }
                importing = false
            case .failure(let error):
                print(error.localizedDescription)
                importing = false
            }
        }
        
        
        
        // MARK: Settings & Quit Buttons
        
        Button("Settings") {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        }
        
        Divider()
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        
        
    }
}

#Preview {
    AppMenu()
}
