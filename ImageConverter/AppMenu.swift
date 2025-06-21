import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var appController: AppController
    
    @State private var isImporting = false
    @State private var isProcessing = false
    
    @State private var isShowingErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Button("Select Images to Convert...") {
                self.isImporting = true
            }
            .disabled(isProcessing)
            
            Divider()
            
            Button("Settings...") {
                openSettings()
            }
            .disabled(isProcessing)
            
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
            if case .success(let files) = result {
                process(files: files)
            } else if case .failure(let error) = result {
                showError(message: error.localizedDescription)
            }
        }
        .onReceive(appController.droppedFilesSubject) { urls in
            process(files: urls)
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
        guard !isProcessing else { return }
        
        self.isProcessing = true
        
        let panel = NSOpenPanel()
        panel.title = "Select Output Folder"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        
        guard panel.runModal() == .OK, let outputDirectory = panel.url else {
            self.isProcessing = false
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for file in files {
                let didStartAccessing = file.startAccessingSecurityScopedResource()
                defer {
                    if didStartAccessing {
                        file.stopAccessingSecurityScopedResource()
                    }
                }
                
                do {
                    let format: ImageFormat = (settings.outputFormat == 0) ? .jpeg(quality: 0.85) : .png
                    let outputData = try ImageConverter.convert(
                        file: file,
                        maxDimension: settings.outputSize,
                        format: format
                    )
                    
                    let originalFilename = file.deletingPathExtension().lastPathComponent
                    let newFilename = "\(originalFilename)-converted.\(format.fileExtension)"
                    let outputURL = outputDirectory.appendingPathComponent(newFilename)
                    try outputData.write(to: outputURL)
                    
                } catch {
                    DispatchQueue.main.async {
                        showError(message: error.localizedDescription)
                        self.isProcessing = false
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.isProcessing = false
            }
        }
    }
}
