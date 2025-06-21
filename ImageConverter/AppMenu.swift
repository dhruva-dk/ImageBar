import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var settings: SettingsStore
    
    // --- STATE MANAGEMENT ---
    // These variables will drive the UI changes
    
    @State private var isImporting = false
    @State private var isProcessing = false
    @State private var processingMessage = ""
    
    // For showing an alert when an error occurs
    @State private var isShowingErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // --- DYNAMIC VIEW ---
            // The view will change based on the 'isProcessing' state
            
            if isProcessing {
                // Show a progress message while working
                Text(processingMessage)
                    .padding(.horizontal)
            } else {
                // Show the "Select Images" button when idle
                Button("Select Images") {
                    self.isImporting = true
                }
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [.image],
                    allowsMultipleSelection: true
                ) { result in
                    // When the file importer closes, this code runs
                    switch result {
                    case .success(let files):
                        // If user selected files, start the main process
                        process(files: files)
                    case .failure(let error):
                        // If there was an error selecting files, show it
                        showError(message: error.localizedDescription)
                    }
                }
            }
            
            Divider()
            
            // --- STANDARD BUTTONS ---
            
            Button("Settings...") {
                openSettings()
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(10)
        // This modifier presents an alert when isShowingErrorAlert becomes true
        .alert("An Error Occurred", isPresented: $isShowingErrorAlert) {
            Button("OK") { } // A simple dismiss button
        } message: {
            Text(errorMessage)
        }
    }
    
    // --- HELPER FUNCTIONS ---
    
    /// Sets the error message and triggers the alert to be shown.
    private func showError(message: String) {
        self.errorMessage = message
        self.isShowingErrorAlert = true
    }
    
    /// The main function to orchestrate the entire conversion workflow.
    private func process(files: [URL]) {
        // 1. Ask the user for a folder to save the converted images
        let panel = NSOpenPanel()
        panel.title = "Select Output Folder"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        
        // Show the panel. If the user clicks "OK"...
        if panel.runModal() == .OK, let outputDirectory = panel.url {
            
            // 2. Set the UI to its "processing" state
            isProcessing = true
            
            // 3. Run the conversion on a background thread to keep the app responsive
            DispatchQueue.global(qos: .userInitiated).async {
                let totalFiles = files.count
                for (index, file) in files.enumerated() {
                    
                    // Update the progress message on the main thread
                    DispatchQueue.main.async {
                        processingMessage = "Converting file \(index + 1) of \(totalFiles)..."
                    }
                    
                    do {
                        // A. Call the conversion engine
                        let format: ImageFormat = (settings.outputFormat == 0) ? .jpeg(quality: 0.85) : .png
                        let outputData = try ImageConverter.convert(
                            file: file,
                            maxDimension: settings.outputSize,
                            format: format
                        )
                        
                        // B. Create a new filename and save the data
                        let originalFilename = file.deletingPathExtension().lastPathComponent
                        let newFilename = "\(originalFilename)-converted.\(format.fileExtension)"
                        let outputURL = outputDirectory.appendingPathComponent(newFilename)
                        
                        try outputData.write(to: outputURL)
                        
                    } catch {
                        // C. If any error occurs, show it and stop processing
                        DispatchQueue.main.async {
                            showError(message: error.localizedDescription)
                            isProcessing = false // Reset UI state
                        }
                        return // Exit the background task
                    }
                }
                
                // 4. Once the loop is finished, reset the UI on the main thread
                DispatchQueue.main.async {
                    isProcessing = false
                    // Optional: You could show a "Done!" alert here
                }
            }
        }
    }
}


#Preview {
    AppMenu()
        .environmentObject(SettingsStore())
}
