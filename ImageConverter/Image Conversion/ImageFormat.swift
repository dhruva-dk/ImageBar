// ImageFormat.swift

import Foundation
import ImageIO
import UniformTypeIdentifiers

enum ImageFormat {
    case jpeg(quality: Double)
    case png
    // We'll add .heic, .webp, etc. here later.
    
    /// The Uniform Type Identifier (UTI) for the format.
    var uti: CFString {
        switch self {
        case .jpeg: return UTType.jpeg.identifier as CFString
        case .png:  return UTType.png.identifier as CFString
        }
    }
    
    /// A dictionary of properties for the image destination.
    var properties: [CFString: Any] {
        switch self {
        case .jpeg(let quality):
            // kCGImageDestinationLossyCompressionQuality is the key for JPEG quality.
            return [kCGImageDestinationLossyCompressionQuality: quality]
        case .png:
            return [:] // PNG has no special properties here.
        }
    }
    
    /// The file extension remains the same.
    var fileExtension: String {
        switch self {
        case .jpeg: "jpg"
        case .png: "png"
        }
    }
}

