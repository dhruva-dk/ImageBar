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
        
        guard let imageRep = nsImage.representations.first as? NSBitmapImageRep else {
            throw ImageConversionError.invalidImageFile(filename)
        }
        let originalPixelSize = NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh)
        
        let newPixelSize = calculateNewSize(for: originalPixelSize, maxDimension: maxDimension)
        
        let resizedImage = try nsImage.resized(toPixels: newPixelSize)
        
        let outputData = try resizedImage.data(for: format)
        
        return outputData
    }
    
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

extension NSImage {
    func resized(toPixels newPixelSize: NSSize) throws -> NSImage {
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(newPixelSize.width),
            pixelsHigh: Int(newPixelSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else {
            throw ImageConversionError.resizeFailed(self.name() ?? "unknown")
        }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        self.draw(in: NSRect(origin: .zero, size: newPixelSize))
        
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: newPixelSize)
        newImage.addRepresentation(rep)
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
