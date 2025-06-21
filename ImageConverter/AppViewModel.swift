import SwiftUI
import UniformTypeIdentifiers // Needed for UTType constants


class AppViewModel: ObservableObject {
    
    // MARK: - Settings Properties
    
    @Published var outputFormat: Int {
        didSet {
            UserDefaults.standard.set(outputFormat, forKey: "outputFormat")
        }
    }
    
    @Published var outputSize: Int {
        didSet {
            UserDefaults.standard.set(outputSize, forKey: "outputSize")
        }
    }

    // MARK: - State Properties
    
    // This single property now replaces both 'isProcessing' and 'errorMessage'.
    @Published var status: Status = .idle

    // MARK: - Initialization
    
    init() {
        self.outputFormat = UserDefaults.standard.integer(forKey: "outputFormat")
        let savedSize = UserDefaults.standard.integer(forKey: "outputSize")
        self.outputSize = savedSize == 0 ? 1200 : savedSize
    }
    
    // MARK: - Business Logic
    
    func process(files: [URL]) {
        // 1. Guard against starting a new process if one is already running.
        guard status != .processing else { return }
      
        // 2. Set the status to 'processing'.
        DispatchQueue.main.async {
            self.status = .processing
        }
        
        let panel = NSOpenPanel()
        panel.title = "Select Output Folder"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        
        guard panel.runModal() == .OK, let outputDirectory = panel.url else {
            // User cancelled the save panel, so we return to idle.
            DispatchQueue.main.async {
                self.status = .idle
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                for file in files {
                    let didStartAccessing = file.startAccessingSecurityScopedResource()
                    defer {
                        if didStartAccessing {
                            file.stopAccessingSecurityScopedResource()
                        }
                    }
                    
                    let format: ImageFormat = (self.outputFormat == 0) ? .jpeg(quality: 0.85) : .png
                    let outputData = try ImageConverter.convert(
                        file: file,
                        maxDimension: self.outputSize,
                        format: format
                    )
                    
                    let originalFilename = file.deletingPathExtension().lastPathComponent
                    let newFilename = "\(originalFilename)-converted.\(format.fileExtension)"
                    let outputURL = outputDirectory.appendingPathComponent(newFilename)
                    try outputData.write(to: outputURL)
                }
                
                // 4. Finished successfully, return to the idle state for now.
                DispatchQueue.main.async {
                    self.status = .idle
                }
                
            } catch {
                // 5. If an error occurs, embed the message directly into the 'failure' state.
                DispatchQueue.main.async {
                    self.status = .failure(message: error.localizedDescription)
                }
            }
        }
    }
}

