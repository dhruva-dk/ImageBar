//
//  ImageFormat.swift
//  ImageBar
//
//  Created by Dhruva Kumar on 6/21/25.
//

import Foundation
import ImageIO
import UniformTypeIdentifiers

enum ImageFormat {
    case jpeg(quality: Double)
    case png
    case heic(quality: Double)
    case tiff
    
    var uti: CFString {
        switch self {
        case .jpeg: return UTType.jpeg.identifier as CFString
        case .png:  return UTType.png.identifier as CFString
        case .heic: return UTType.heic.identifier as CFString
        case .tiff: return UTType.tiff.identifier as CFString
        }
    }
    
    var properties: [CFString: Any] {
        switch self {
        case .jpeg(let quality), .heic(let quality):
            return [kCGImageDestinationLossyCompressionQuality: quality]
        case .png, .tiff:
            return [:]
        }
    }
    
    var fileExtension: String {
        switch self {
        case .jpeg: "jpg"
        case .png: "png"
        case .heic: "heic"
        case .tiff: "tiff"
        }
    }
}
