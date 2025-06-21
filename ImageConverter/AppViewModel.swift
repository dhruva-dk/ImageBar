import SwiftUI
import UniformTypeIdentifiers // Needed for UTType constants

// The class is renamed to reflect its broader responsibilities.
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

    // MARK: - State Properties (Moved from AppMenu)
    
    /// True when the app is busy converting images. The View will observe this to disable buttons.
    @Published var isProcessing = false
    
    /// Holds the description of the latest error. The View will observe this to present an alert.
    /// Using an optional String is a common pattern for driving alerts.
    @Published var errorMessage: String? = nil

    // MARK: - Initialization
    
    init() {
        self.outputFormat = UserDefaults.standard.integer(forKey: "outputFormat")
        let savedSize = UserDefaults.standard.integer(forKey: "outputSize")
        self.outputSize = savedSize == 0 ? 1200 : savedSize
    }
    
    // MARK: - Business Logic (Moved from AppMenu)
    
    /// This is the core business logic, now owned by the ViewModel.
    func process(files: [URL]) {
        guard !isProcessing else { return }
        
        // This published property is now updated on the main thread from within the ViewModel.
        self.isProcessing = true
        
        let panel = NSOpenPanel()
        panel.title = "Select Output Folder"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        
        guard panel.runModal() == .OK, let outputDirectory = panel.url else {
            // User cancelled the save panel, so we stop processing.
            DispatchQueue.main.async {
                self.isProcessing = false
            }
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
                    // Logic now reads settings directly from the ViewModel's properties.
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
                    
                } catch {
                    // On error, we update the errorMessage property on the main thread.
                    // The view will automatically react to this change.
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.isProcessing = false
                    }
                    return // Stop processing the rest of the files on the first error.
                }
            }
            
            // Finished successfully, update the state on the main thread.
            DispatchQueue.main.async {
                self.isProcessing = false
            }
        }
    }
}

