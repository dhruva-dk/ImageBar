import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    
    // The view now depends on the AppViewModel.
    @EnvironmentObject var appViewModel: AppViewModel

    // This state is purely for the view's fileImporter presentation. It's fine to keep it here.
    @State private var isImporting = false
    
    // We create a computed binding to determine if the alert should be shown.
    // This is a clean way to bridge the ViewModel's optional error string to the alert's isPresented boolean.
    private var isShowingErrorAlert: Binding<Bool> {
        Binding(
            get: { appViewModel.errorMessage != nil },
            set: { _ in
                // When the alert is dismissed, we clear the error message in the ViewModel.
                appViewModel.errorMessage = nil
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Button("Select Images to Convert...") {
                self.isImporting = true
            }
            // The disabled state is now driven by the ViewModel's published property.
            .disabled(appViewModel.isProcessing)
            
            Divider()
            
            Button("Settings...") {
                openSettings()
            }
            .disabled(appViewModel.isProcessing)
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(10)
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.image],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let files):
                // The view simply tells the ViewModel to process the files.
                // It doesn't know or care how the processing is done.
                appViewModel.process(files: files)
            case .failure(let error):
                // If the file importer itself fails, we can set the error on the ViewModel.
                appViewModel.errorMessage = error.localizedDescription
            }
        }
        .alert(
            "An Error Occurred",
            isPresented: isShowingErrorAlert, // Use our computed binding
            actions: { Button("OK") {} },
            message: {
                // The message text comes directly from the ViewModel.
                Text(appViewModel.errorMessage ?? "An unknown error occurred.")
            }
        )
    }
}
