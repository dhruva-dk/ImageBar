import SwiftUI

struct AppMenu: View {

    
    @Environment(\.openSettings) private var openSettings
    
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
        
        
        
        Divider()
        
        // MARK: Settings & Quit Buttons
        
        Button("Settings") {
            openSettings()
        }
        

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        
        
    }
}

#Preview {
    AppMenu()
}
