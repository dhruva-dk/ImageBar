import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var settings: SettingsStore
    
    @State private var isImporting = false
    @State private var isProcessing = false
    
    @State private var isShowingErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button("Select Images to Convert...") {
                print("UI: 'Select Images' button clicked.")
                self.isImporting = true
            }
            .disabled(isProcessing)
            
            Divider()
            
            Button("Settings...") {
                openSettings()
            }
            
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
            print("UI: fileImporter completed.")
            if case .success(let files) = result {
                print("UI: fileImporter success. Received \(files.count) file(s).")
                process(files: files)
            } else if case .failure(let error) = result {
                print("UI: fileImporter failed with error: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
            }
        }
        .alert("An Error Occurred", isPresented: $isShowingErrorAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.isShowingErrorAlert = true
    }
    
    private func process(files: [URL]) {
        print("PROCESS: Starting process function with \(files.count) file(s).")
        
        self.isProcessing = true
        
        let panel = NSOpenPanel()
        panel.title = "Select Output Folder"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        print("PROCESS: Showing NSOpenPanel to select output directory.")
        
        guard panel.runModal() == .OK, let outputDirectory = panel.url else {
            print("PROCESS: User cancelled the output panel.")
            self.isProcessing = false
            return
        }
        print("PROCESS: User selected output directory: \(outputDirectory.path)")
        
        for file in files {
            print("\nPROCESS: --- Starting loop for file: \(file.lastPathComponent) ---")
            
            print("PROCESS: Attempting to start security-scoped access...")
            let didStartAccessing = file.startAccessingSecurityScopedResource()
            print("PROCESS: startAccessingSecurityScopedResource() returned: \(didStartAccessing)")
            
            defer {
                if didStartAccessing {
                    file.stopAccessingSecurityScopedResource()
                    print("PROCESS: --- In defer block, stopped security access for \(file.lastPathComponent) ---")
                }
            }
            
            do {
                let format: ImageFormat = (settings.outputFormat == 0) ? .jpeg(quality: 0.85) : .png
                print("PROCESS: Calling ImageConverter with format: \(format) and size: \(settings.outputSize)")
                
                let outputData = try ImageConverter.convert(
                    file: file,
                    maxDimension: settings.outputSize,
                    format: format
                )
                print("PROCESS: Successfully converted data, size: \(outputData.count) bytes.")
                
                let originalFilename = file.deletingPathExtension().lastPathComponent
                let newFilename = "\(originalFilename)-converted.\(format.fileExtension)"
                let outputURL = outputDirectory.appendingPathComponent(newFilename)
                
                print("PROCESS: Attempting to write data to: \(outputURL.path)")
                try outputData.write(to: outputURL)
                print("PROCESS: Successfully wrote file.")
                
            } catch {
                print("PROCESS: 🔴 ERROR CAUGHT IN PROCESS FUNCTION: \(error)")
                print("PROCESS: 🔴 Error's Localized Description: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
                self.isProcessing = false
                return
            }
        }
        
        print("\nPROCESS: Finished loop successfully.")
        self.isProcessing = false
    }
}
