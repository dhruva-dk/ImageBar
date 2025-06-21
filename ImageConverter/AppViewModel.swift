import SwiftUI
import UniformTypeIdentifiers
import Combine


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
    
    @Published var quality: Double {
        didSet {
            UserDefaults.standard.set(quality, forKey: "quality")
        }
    }
    


    // MARK: - State Properties
    
    @Published var status: Status = .idle
    
    private var statusTimer: AnyCancellable?

    // MARK: - Initialization
    
    init() {
        self.outputFormat = UserDefaults.standard.integer(forKey: "outputFormat")
        let savedSize = UserDefaults.standard.integer(forKey: "outputSize")
        self.outputSize = savedSize == 0 ? 1200 : savedSize
        let savedQuality = UserDefaults.standard.double(forKey: "quality")
        self.quality = (savedQuality == 0) ? 0.85 : savedQuality // Default to 85% quality
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
                    
                    let format: ImageFormat
                                        switch self.outputFormat {
                                        case 0: // JPEG
                                            format = .jpeg(quality: self.quality)
                                        case 1: // PNG
                                            format = .png
                                        case 2: // HEIC
                                            format = .heic(quality: self.quality)
                                        case 3: // TIFF
                                            format = .tiff
                                        default:
                                            // Fallback to PNG if something is wrong
                                            format = .png
                                        }
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
                
                let successMessage = "\(files.count) image(s) converted."
                
                DispatchQueue.main.async {
                    // Set the new success status, passing in the message and directory URL
                    // NOTE: Make sure your Status enum has the .success case defined.
                    self.status = .success(message: successMessage, outputURL: outputDirectory)
                    
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

