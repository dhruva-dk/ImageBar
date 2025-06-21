// In ImageFormat.swift

import Foundation
import ImageIO
import UniformTypeIdentifiers

enum ImageFormat {
    case jpeg(quality: Double)
    case png
    // --- ADD NEW FORMATS ---
    case heic(quality: Double)
    case tiff
    
    var uti: CFString {
        switch self {
        case .jpeg: return UTType.jpeg.identifier as CFString
        case .png:  return UTType.png.identifier as CFString
        // --- ADD NEW UTI's ---
        case .heic: return UTType.heic.identifier as CFString
        case .tiff: return UTType.tiff.identifier as CFString
        }
    }
    
    var properties: [CFString: Any] {
        switch self {
        case .jpeg(let quality), .heic(let quality): // HEIC uses the same quality key
            return [kCGImageDestinationLossyCompressionQuality: quality]
        case .png, .tiff:
            return [:] // Use default settings for PNG and TIFF
        }
    }
    
    var fileExtension: String {
        switch self {
        case .jpeg: "jpg"
        case .png: "png"
        // --- ADD NEW EXTENSIONS ---
        case .heic: "heic"
        case .tiff: "tiff"
        }
    }
}
