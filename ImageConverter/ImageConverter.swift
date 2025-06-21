//
//  ImageConverterViewModel.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/20/25.
//

import SwiftUI
import AppKit

enum ImageConversionError: Error, LocalizedError {
    case invalidImageFile(String)
    case resizeFailed(String)
    case dataRepresentationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidImageFile(let filename):
            return "Could not read the file '\(filename)'. It may be corrupt or an unsupported format."
        case .resizeFailed(let filename):
            return "An internal error occurred while resizing '\(filename)'."
        case .dataRepresentationFailed(let filename):
            return "An internal error occurred while converting '\(filename)' to the target format."
        }
    }
}

enum ImageFormat {
    case jpeg(quality: Double)
    case png
    
    var fileExtension: String {
        switch self {
        case .jpeg: "jpg"
        case .png: "png"
        }
    }
}

struct ImageConverter {
    static func convert(
        file: URL,
        maxDimension: Int,
        format: ImageFormat
    ) throws -> Data {
        
        let filename = file.lastPathComponent
        
        guard let nsImage = NSImage(contentsOf: file) else {
            throw ImageConversionError.invalidImageFile(filename)
        }
        
        let newSize = calculateNewSize(for: nsImage.size, maxDimension: maxDimension)
        
        let resizedImage = try nsImage.resized(to: newSize)
        
        let outputData = try resizedImage.data(for: format)
        
        return outputData
    }
    
    
    // MARK: - Calculate New size with math
    
    
    private static func calculateNewSize(for originalSize: NSSize, maxDimension: Int) -> NSSize {
        let max = CGFloat(maxDimension)
        if originalSize.width <= max && originalSize.height <= max {
            return originalSize
        }
        
        if originalSize.width > originalSize.height {
            let newWidth = max
            let newHeight = (originalSize.height / originalSize.width) * newWidth
            return NSSize(width: newWidth, height: newHeight)
        } else {
            let newHeight = max
            let newWidth = (originalSize.width / originalSize.height) * newHeight
            return NSSize(width: newWidth, height: newHeight)
        }
    }
}



// MARK: NSImage Extension for Resizing and File Conversion

extension NSImage {
    func resized(to newSize: NSSize) throws -> NSImage {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        self.draw(in: NSRect(origin: .zero, size: newSize),
                  from: NSRect(origin: .zero, size: self.size),
                  operation: .sourceOver,
                  fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    

    func data(for format: ImageFormat) throws -> Data {
        guard let tiffRepresentation = self.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            
            let imageName = self.name() ?? "unknown file"
            throw ImageConversionError.dataRepresentationFailed(imageName)
        }
        
        let properties: [NSBitmapImageRep.PropertyKey : Any]
        let imageType: NSBitmapImageRep.FileType
        
        switch format {
        case .jpeg(let quality):
            imageType = .jpeg
            properties = [.compressionFactor: quality]
        case .png:
            imageType = .png
            properties = [:]
        }
        
        guard let outputData = bitmapImage.representation(using: imageType, properties: properties) else {
            
            let imageName = self.name() ?? "unknown file"
            throw ImageConversionError.dataRepresentationFailed(imageName)
        }
        
        return outputData
    }
}
