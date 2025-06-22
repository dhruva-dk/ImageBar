//
//  AppViewModel.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/21/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Combine

class AppViewModel: ObservableObject {
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
    
    @Published var convertedFileSuffix: String {
        didSet {
            UserDefaults.standard.set(convertedFileSuffix, forKey: "convertedFileSuffix")
        }
    }
    
    @Published var status: Status = .idle
    private var statusTimer: AnyCancellable?
    
    init() {
        self.outputFormat = UserDefaults.standard.integer(forKey: "outputFormat")
        let savedSize = UserDefaults.standard.integer(forKey: "outputSize")
        self.outputSize = savedSize == 0 ? 1200 : savedSize
        let savedQuality = UserDefaults.standard.double(forKey: "quality")
        self.quality = (savedQuality == 0) ? 0.85 : savedQuality
        self.convertedFileSuffix = UserDefaults.standard.string(forKey: "convertedFileSuffix") ?? "-converted"
    }
    
    func process(files: [URL]) {
        guard status != .processing else { return }
      
        DispatchQueue.main.async {
            self.status = .processing
        }
        
        let panel = NSOpenPanel()
        panel.title = "Select Output Folder"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        
        guard panel.runModal() == .OK, let outputDirectory = panel.url else {
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
                    case 0:
                        format = .jpeg(quality: self.quality)
                    case 1:
                        format = .png
                    case 2:
                        format = .heic(quality: self.quality)
                    case 3:
                        format = .tiff
                    default:
                        format = .png
                    }
                    let outputData = try ImageConverter.convert(
                        file: file,
                        maxDimension: self.outputSize,
                        format: format
                    )
                    
                    let originalFilename = file.deletingPathExtension().lastPathComponent
                    let convertedFileSuffix = self.convertedFileSuffix
                    
                    
                    let newFilename = "\(originalFilename)\(convertedFileSuffix).\(format.fileExtension)"
                    let outputURL = outputDirectory.appendingPathComponent(newFilename)
                    try outputData.write(to: outputURL)
                }
                
                let successMessage = "\(files.count) image(s) converted."
                
                DispatchQueue.main.async {
                    self.status = .success(message: successMessage, outputURL: outputDirectory)
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.status = .failure(message: error.localizedDescription)
                }
            }
        }
    }
}
